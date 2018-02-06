function f = objecfun(Jnew,Jold)
f = sqrt(trace((Jnew-Jold)'*(Jnew-Jold)));
end