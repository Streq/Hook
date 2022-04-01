extends Node

const sqrt_2_inv = 1.0/sqrt(2.0)

func modulo(val:int, size:int)->int:
	return ((val % size) + size) % size

func fmodulo(val:float, size:float)->float:
	return fmod((fmod(val,size) + size), size)
