import xml.etree.ElementTree
import os
import re

def find(root,path,ns):
  if ns:
    new_path = path.replace("//","//ns:")
    return root.find(new_path,ns)
  else:
    return root.find(path)

def findall(root,path,ns):
  if ns:
    new_path = path.replace("//","//ns:")
    return root.findall(new_path,ns)
  else:
    return root.findall(path)

def opt(s):
  return s if s is not None else ""

class Line :
  def read_line(self, line_node):
    self.text = ""
    for seg in findall(line_node,'.//seg',self.ns):
      self.text += opt(seg.text)
      for sb in findall(seg,'.//sb',self.ns):
        self.text += opt(sb.tail)
      for caesura in findall(seg,'.//caesura',self.ns):
        self.text += opt(caesura.tail)
      for rhyme in findall(seg,'.//rhyme',self.ns):
        self.text += opt(rhyme.text)
        for sb in findall(rhyme,'.//sb',self.ns):
          self.text += opt(sb.tail)
        for caesura in findall(rhyme,'.//caesura',self.ns):
          self.text += opt(caesura.tail)
        self.text += opt(rhyme.tail)
  def write(self,f):
    f.write(self.text + "\n")
    f.write(self.real_meter + "\n")
  def __init__(self,line_node, ns):
    self.ns = ns
    self.read_line(line_node)
    self.meter = line_node.attrib['met'] if 'met' in line_node.attrib else ""
    self.real_meter = line_node.attrib['real'] if 'real' in line_node.attrib else ""

class Poem :
  def create_lines(self, root):
    self.lines = []
    for l in findall(root,'.//l',self.ns):
      self.lines.append(Line(l,self.ns))

  def set_namespace(self, root):
    namespace = re.match("{(.*)}",root.tag)
    self.ns = {}
    if namespace:
      self.ns['ns'] = namespace.group(1)

  def write(self):
    f = open('data/text_poems/'+self.author + " - " + self.title + ".txt", 'w')
    for line in self.lines:
      line.write(f)

  def __init__(self,filename):
    self.filename = filename

    root = xml.etree.ElementTree.parse(filename).getroot()

    self.set_namespace(root)

    self.author = find(root,'.//author',self.ns).text
    self.title = find(root,'.//title',self.ns).text
    self.create_lines(root)

    self.write()

for filename in os.listdir('data/xml_poems'):
  if not filename.endswith('.xml'): continue
  print(filename)
  p = Poem('data/xml_poems/'+filename)
