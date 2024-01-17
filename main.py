import myParser
from functools import reduce
from environment import Env

file_in = "myCode.ms"
file_out = "mips1.asm"

def main():
    parser = myParser.Parser()

    while True:
        inp = input(">>> ")
        if (inp == None) or ("exit" in inp) or (inp == ""):
            exit(1)
        program = parser.produce_AST(inp)
        print(program)
    
def from_file():
    parser = myParser.Parser()
    lines = ""
    try:
        with open(file_in) as file:
            lines = reduce(lambda a, b: a + b, file.readlines())
    except FileNotFoundError as e:
        print(e, "Incorrect File Path")
    file.close()
    program = parser.produce_AST(lines)
    return program

def from_to_file():
    env = Env()
    code = from_file().generate_code(env)
    #print(code)
    file = open(file_out, "w")
    file.write(code)
    file.close()

def test():
   print(abs(hash("prop1")))
   print(abs(hash("prop2")))
   print(abs(hash("prop3")))

if __name__ == "__main__":
    #from_to_file()
    test()
    #from_file()
