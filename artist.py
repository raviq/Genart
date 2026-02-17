# Drawing of repeated random walks using random colors for each walk.

from turtle import *
from random import randint, uniform

width, height = 1000, 1000

def random_move(turtle, distance):
	# turn turtle through random angle and move forward by random distance
	angle = uniform(-90, 90)
	d = uniform(0,distance)
	
	turtle.color(randcolor(), randcolor())
		
	turtle.left(angle)
	turtle.forward(d)
  
def randcolor():
	return (randint(0, 255), randint(0, 255), randint(0, 255))
  
def gohome(turtle):
	# send turtle home without leaving a track.
	turtle.penup()
	turtle.goto(0, 0)
	turtle.pendown()

def random_walk(turtle, distance, steps):
	# Send turtle on random walk.	
	fred.pensize(1)
	for step in range(0, steps):
		random_move(turtle, distance)  
	gohome(turtle)

def repeat(trials):
	steps = 5000 # length of one branch?
	while True:
		random_walk(fred, 5, steps)
  
fred = Turtle()

fred.speed("fastest")
fred.dot(2, "red")

colormode(255)
bgcolor("black")

print (' width, height = %d, %d' % (width, height) )

setup( width, height, startx = None, starty = None)

repeat(20)



