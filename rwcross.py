
import turtle
import random
import numpy as np
from random import uniform, randint
import math

def angle_wrt_x(A,B):
    """
    Return the angle between B-A and the positive x-axis.
    Values go from 0 to pi in the upper half-plane, and from 
    0 to -pi in the lower half-plane.
    """
    ax, ay = A
    bx, by = B
    return math.atan2(by-ay, bx-ax)

def dist(A, B):
    ax, ay = A
    bx, by = B
    return math.hypot(bx-ax, by-ay)

class Walker(turtle.Turtle):
    def __init__(self, name, *args, **kwargs):
        super(Walker, self).__init__(*args, **kwargs)
        self.name = name 
        self.container = 0
    def get_name(self):
    	return self.name
    def set_container(self, container):
    	self.container = container
    	if container:
	    	print '%s: I am in %s.' % (self.name, container.get_name())
    def get_container(self):
    	return self.container

class Distinction(object):
	def __init__(self, x, y, side, name=''):
		self.x, self.y, self.side, self.name = x, y, side, name
	def get_name(self):
		return self.name
	def draw(self):
		turtle.penup()
		turtle.setposition(self.x, self.y)
		turtle.pendown()
		turtle.color('blue')
		for _ in xrange(4):
			turtle.left(90)
			turtle.fd(self.side)
		
	def contains(self, walker):
		b = (walker.xcor() <= self.x and walker.xcor() >= (self.x - self.side)) and \
		(walker.ycor() >= self.y and walker.ycor() <= (self.y + self.side))
		return b

def init():
	turtle.speed(0)

	a = Distinction(-100, -100, 220, 'a')
	a.draw()

	b = Distinction(-130, -70, 130, 'b')
	b.draw()

	c = Distinction(10, 20, 100, 'c')
	c.draw()

	d = Distinction(200, 200, 80, 'd')
	d.draw()

	e = Distinction(100, 200, 50, 'e')
	e.draw()

	f = Distinction(200, -250, 200, 'f')
	f.draw()

	g = Distinction(180, -200, 80, 'f')
	g.draw()

	turtle.penup()
	turtle.setposition(0, 0)
	turtle.pendown()
	turtle.color('black')
	
	return a, b, c, d, e, f, g

if __name__ == '__main__':

	a, b, c, d, e, f, g = init()

	w = Walker('Walky')
	w.pensize(1)
	w.speed(0)

	while True:

		if (-300 < w.xcor() <300) and (-300 < w.ycor() <300):

			w.right(uniform(-90, 90) )		
			w.forward(randint(1, 10))

			if a.contains(w):
				w.set_container(a)
				w.color('red')

			elif b.contains(w):
				w.set_container(b)
				w.color('red')
				
			elif c.contains(w):
				w.set_container(c)
				w.color('red')
				
			elif d.contains(w):
				w.set_container(d)
				w.color('red')
				
			elif e.contains(w):
				w.set_container(e)
				w.color('red')
				
			elif f.contains(w):
				w.set_container(f)			
				w.color('red')
				
			elif g.contains(w):
				w.set_container(g)			
				w.color('red')
				
			else:
				w.color('black')
				
				if w.get_container():
					print '%s: I just left %s.' % (w.get_name(), w.get_container().get_name())
				
				w.set_container(0)
				

		else:
			beta = angle_wrt_x([w.xcor(), w.ycor()], [0, 0])
			
			
			w.right(180-beta)

			w.forward(randint(50, 100))


		
			

