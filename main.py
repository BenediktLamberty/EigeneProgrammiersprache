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

def test():
    code = """
jklasdjfklöj
alöksdjflköjas
ddfjlöjkaölsdkjf
    """
    code += """
alöskdjflökj
asdfjlökjölk
asdfjölkjölkj
    """
    print(code)


if __name__ == "__main__":
    env = Env()
    code = from_file().generate_code(env)
    print(code)