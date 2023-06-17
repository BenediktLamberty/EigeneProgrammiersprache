import myParser
from functools import reduce
from environment import Env

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
    with open("bsp.txt") as file:
        lines = reduce(lambda a, b: a + b, file.readlines())
    file.close()
    program = parser.produce_AST(lines)
    print(program)
    return program

def from_to_file():
    env = Env()
    code = from_file().generate_code(env)
    #print(code)
    file = open("mips1.asm", "w")
    file.write(code)
    file.close()

def test():
    a = "jlhkasdjf"
    b = "jlhk"+"asdjf"
    print(str(hash(a) % 2_147_483_647))
    print(str(hash(b) % 2_147_483_647))

if __name__ == "__main__":
    #from_to_file()
    test()
    #from_file()
