from __future__ import absolute_import
#import tensorflow as tf
import numpy as np
import scipy as sp
import GPy
from GPy import Model
from GPy.core.gp import GP
from GPy.core.sparse_gp import SparseGP
from GPy import likelihoods
#from paramz import Param
from GPy.core.parameterization.variational import VariationalPosterior
from GPy.core.parameterization.param import Param



#from gpflow.model import GPModel
#from gpflow.param import Param, DataHolder
#from gpflow.mean_functions import Zero
#from gpflow import likelihoods
#from gpflow._settings import settings
#from gpflow.densities import multivariate_normal
#from gpflow._settings import settings
#float_type = settings.dtypes.float_type
float_type = np.float64
#
#tf.zeros(tf.stack([tf.shape(X)[0], 1]), dtype=float_type)
#np.zeros(np.vstack((np.shape(X)[0],1)),dtype= float_type)



class OSGPR_VFE(GP):
    """
    Online Sparse Variational GP regression.
    
    Streaming Gaussian process approximations
    Thang D. Bui, Cuong V. Nguyen, Richard E. Turner
    NIPS 2017
    """

    def __init__(self, X, Y, kern, mu_old, Su_old, Kaa_old, Z_old, Z, mean_function=None):
        """
        X is a data matrix, size N x D
        Y is a data matrix, size N x R
        Z is a matrix of pseudo inputs, size M x D
        kern, mean_function are appropriate gpflow objects
        mu_old, Su_old are mean and covariance of old q(u)
        Z_old is the old inducing inputs
        This method only works with a Gaussian likelihood.
        """


        
#        X = X
#        Y=Y
        
        
        self.X = Param('input',X)
        self.Y = Param('output',Y)
        
        
        likelihood = likelihoods.Gaussian()
#        GPModel.__init__(self, X, Y, kern, likelihood, mean_function)
        GP.__init__(self, X, Y, kern, likelihood, mean_function, inference_method = GPy.inference.latent_function_inference.VarDTC())
#        GP.__init__(self, X, Y, kern, likelihood, mean_function)
     
#        SparseGP.__init__(self, X, Y, Z, kern, likelihood, mean_function, inference_method = GPy.inference.latent_function_inference.VarDTC())
#        SparseGP.__init__(self, X, Y, Z, kern, likelihood, mean_function, inference_method = None)
       
        self.Z = Param('inducing inputs',Z)       
        self.link_parameter(self.Z)
        self.mean_function = mean_function
        self.num_data = X.shape[0]
        self.num_latent = Y.shape[1]

        self.mu_old = mu_old
        self.M_old = Z_old.shape[0]
        self.Su_old = Su_old
        self.Kaa_old = Kaa_old
        self.Z_old = Z_old


    def _build_common_terms(self):

        Mb = np.shape(self.Z)[0]
        Ma = self.M_old
#        jitter = settings.numerics.jitter_level
        jitter = 1e-4
        sigma2 = self.likelihood.variance
        sigma = np.sqrt(sigma2)

        Saa = self.Su_old
        ma = self.mu_old

        # a is old inducing points, b is new
        # f is training points
        # s is test points
        Kbf = self.kern.K(self.Z, self.X)
        Kbb = self.kern.K(self.Z) + np.eye(Mb, dtype=float_type) * jitter
#        print(np.linalg.eigvalsh(Saa))
        
        
        Kba = self.kern.K(self.Z, self.Z_old)
        Kaa_cur = self.kern.K(self.Z_old) + np.eye(Ma, dtype=float_type) * jitter
        Kaa = self.Kaa_old + np.eye(Ma, dtype=float_type) * jitter

#        err = self.Y - self.mean_function(self.X)
        err = self.Y 

        Sainv_ma = np.linalg.solve(Saa, ma)
        Sinv_y = self.Y / sigma2
        c1 = np.matmul(Kbf, Sinv_y)
        c2 = np.matmul(Kba, Sainv_ma)
        c = c1 + c2

        Lb = np.linalg.cholesky(Kbb)
        Lbinv_c = sp.linalg.solve_triangular(Lb, c, lower=True)
        Lbinv_Kba = sp.linalg.solve_triangular(Lb, Kba, lower=True)
        Lbinv_Kbf = sp.linalg.solve_triangular(Lb, Kbf, lower=True) / sigma
        d1 = np.matmul(Lbinv_Kbf, np.transpose(Lbinv_Kbf))

        LSa = np.linalg.cholesky(Saa)
        Kab_Lbinv = np.transpose(Lbinv_Kba)
        LSainv_Kab_Lbinv = sp.linalg.solve_triangular(
            LSa, Kab_Lbinv, lower=True)
        d2 = np.matmul(np.transpose(LSainv_Kab_Lbinv), LSainv_Kab_Lbinv)

        La = np.linalg.cholesky(Kaa)
        Lainv_Kab_Lbinv = sp.linalg.solve_triangular(
            La, Kab_Lbinv, lower=True)
        d3 = np.matmul(np.transpose(Lainv_Kab_Lbinv), Lainv_Kab_Lbinv)

        D = np.eye(Mb, dtype=float_type) + d1 + d2 - d3
        D = D + np.eye(Mb, dtype=float_type) * jitter
        
#        E = np.linalg.eigvalsh(D)
#        
#        print(np.any(np.linalg.eigvalsh(D) < 0))
#        print(np.min(E))
#        print(np.linalg.eigvalsh(D))

        LD = np.linalg.cholesky(D)
        

        LDinv_Lbinv_c = sp.linalg.solve_triangular(LD, Lbinv_c, lower=True)

        return (Kbf, Kba, Kaa, Kaa_cur, La, Kbb, Lb, D, LD,
                Lbinv_Kba, LDinv_Lbinv_c, err, d1)

    def log_likelihood(self):
        """
        Construct a function to compute the bound on the marginal
        likelihood. 
        """

        Mb = np.shape(self.Z)[0]
        Ma = self.M_old
#        jitter = settings.numerics.jitter_level
        jitter = 1e-4
        sigma2 = self.likelihood.variance
        sigma = np.sqrt(sigma2)
        N = self.num_data

        Saa = self.Su_old
        ma = self.mu_old

        # a is old inducing points, b is new
        # f is training points
        Kfdiag = self.kern.Kdiag(self.X)
        (Kbf, Kba, Kaa, Kaa_cur, La, Kbb, Lb, D, LD,
            Lbinv_Kba, LDinv_Lbinv_c, err, Qff) = self._build_common_terms()

        LSa = np.linalg.cholesky(Saa)
        Lainv_ma = sp.linalg.solve_triangular(LSa, ma, lower=True)

        bound = 0
        # constant term
        bound = -0.5 * N * np.log(2 * np.pi)
        # quadratic term
        bound += -0.5 * np.sum(np.square(err)) / sigma2
        # bound += -0.5 * tf.reduce_sum(ma * Sainv_ma)
        bound += -0.5 * np.sum(np.square(Lainv_ma))
        bound += 0.5 * np.sum(np.square(LDinv_Lbinv_c))
        # log det term
        bound += -0.5 * N * np.sum(np.log(sigma2))
        bound += - np.sum(np.log(np.diag(LD)))

        # delta 1: trace term
        bound += -0.5 * np.sum(Kfdiag) / sigma2
        bound += 0.5 * np.sum(np.diag(Qff))

        # delta 2: a and b difference
        bound += np.sum(np.log(np.diag(La)))
        bound += - np.sum(np.log(np.diag(LSa)))

        Kaadiff = Kaa_cur - np.matmul(np.transpose(Lbinv_Kba), Lbinv_Kba)
        Sainv_Kaadiff = np.linalg.solve(Saa, Kaadiff)
        Kainv_Kaadiff = np.linalg.solve(Kaa, Kaadiff)

        bound += -0.5 * np.sum(
            np.diag(Sainv_Kaadiff) - np.diag(Kainv_Kaadiff))
        
        
        return bound
    
    
    def predict(self, Xnew, full_cov=False):
        """
        Compute the mean and variance of the latent function at some new points
        Xnew. 
        """

        # jitter = settings.numerics.jitter_level
        jitter = 1e-4

        # a is old inducing points, b is new
        # f is training points
        # s is test points
        Kbs = self.kern.K(self.Z, Xnew)
        (Kbf, Kba, Kaa, Kaa_cur, La, Kbb, Lb, D, LD,
            Lbinv_Kba, LDinv_Lbinv_c, err, Qff) = self._build_common_terms()

        Lbinv_Kbs = sp.linalg.solve_triangular(Lb, Kbs, lower=True)
        LDinv_Lbinv_Kbs = sp.linalg.solve_triangular(LD, Lbinv_Kbs, lower=True)
        mean = np.matmul(np.transpose(LDinv_Lbinv_Kbs), LDinv_Lbinv_c)

        if full_cov:
            Kss = self.kern.K(Xnew) + jitter * np.eye(np.shape(Xnew)[0], dtype=float_type)
            var1 = Kss
            var2 = - np.matmul(np.transpose(Lbinv_Kbs), Lbinv_Kbs)
            var3 = np.matmul(np.transpose(LDinv_Lbinv_Kbs), LDinv_Lbinv_Kbs)
            var = var1 + var2 + var3
        else:
            var1 = self.kern.Kdiag(Xnew)
            var2 = -np.sum(np.square(Lbinv_Kbs), 0)
            var3 = np.sum(np.square(LDinv_Lbinv_Kbs), 0)
            var = var1 + var2 + var3

        return mean, var

    def parameters_changed(self):
        self.posterior, self._log_marginal_likelihood, self.grad_dict = \
        self.inference_method.inference(self.kern, self.X, self.Z, self.likelihood,
                                        self.Y_normalized, Y_metadata=self.Y_metadata,
                                        mean_function=self.mean_function)
        self._update_gradients()

    def _update_gradients(self):
        self.likelihood.update_gradients(self.grad_dict['dL_dthetaL'])
        if self.mean_function is not None:
            self.mean_function.update_gradients(self.grad_dict['dL_dm'], self.X)

        if isinstance(self.X, VariationalPosterior):
            #gradients wrt kernel
            dL_dKmm = self.grad_dict['dL_dKmm']
            self.kern.update_gradients_full(dL_dKmm, self.Z, None)
            kerngrad = self.kern.gradient.copy()
            self.kern.update_gradients_expectations(variational_posterior=self.X,
                                                    Z=self.Z,
                                                    dL_dpsi0=self.grad_dict['dL_dpsi0'],
                                                    dL_dpsi1=self.grad_dict['dL_dpsi1'],
                                                    dL_dpsi2=self.grad_dict['dL_dpsi2'])
            self.kern.gradient += kerngrad

            #gradients wrt Z
            self.Z.gradient = self.kern.gradients_X(dL_dKmm, self.Z)
            self.Z.gradient += self.kern.gradients_Z_expectations(
                               self.grad_dict['dL_dpsi0'],
                               self.grad_dict['dL_dpsi1'],
                               self.grad_dict['dL_dpsi2'],
                               Z=self.Z,
                               variational_posterior=self.X)
        else:
            #gradients wrt kernel
            self.kern.update_gradients_diag(self.grad_dict['dL_dKdiag'], self.X)
            kerngrad = self.kern.gradient.copy()
            self.kern.update_gradients_full(self.grad_dict['dL_dKnm'], self.X, self.Z)
            kerngrad += self.kern.gradient
            self.kern.update_gradients_full(self.grad_dict['dL_dKmm'], self.Z, None)
            self.kern.gradient += kerngrad
            #gradients wrt Z
            self.Z.gradient = self.kern.gradients_X(self.grad_dict['dL_dKmm'], self.Z)
            self.Z.gradient += self.kern.gradients_X(self.grad_dict['dL_dKnm'].T, self.Z, self.X)
        self._Zgrad = self.Z.gradient.copy()

