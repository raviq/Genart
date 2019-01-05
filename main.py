# Random Walking Artists

from turtle import *
from random import randint, uniform

def random_move(turtle, distance):
	# turn turtle through random angle and move forward by random distance
	angle = uniform(-90, 90)
	d = uniform(0,distance)
	turtle.left(angle)
	turtle.forward(d)
  
def randcolor():
	# return random color --- a 3-tupe
	return (randint(0, 255), randint(0, 255), randint(0, 255))
  
def gohome(turtle):
	# send turtle home without leaving a track.
	turtle.penup()
	turtle.goto(0, 0)
	turtle.pendown()

def random_walk(turtle, distance, steps):
	# Send turtle on random walk.
	turtle.color(randcolor(), randcolor())
	for step in range(0, steps):
		random_move(turtle, distance)  
	gohome(turtle)

def repeat(trials):
	steps = 1000 # length of one branch?
	while True:
		random_walk(fred, 5, steps)

fred = Turtle()

fred.speed("fastest")
fred.dot(2, "red")

colormode(255)
bgcolor("black")

repeat(20)


