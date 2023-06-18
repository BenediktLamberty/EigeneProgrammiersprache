from environment import Env
import sys
from functools import reduce
from myParser import Parser

def run_from_cmd():
    input_file = "myCode.ms"
    inter_file = "mips1.asm"
    print_ast = False
    comp = True
    if len(sys.argv) == 2:
        input_file = sys.argv[1]
    elif len(sys.argv) >= 2:
        input_file = sys.argv[1]
        for arg in sys.argv[2:]:
            if arg == "ast": print_ast = True
            elif arg == "nocomp": comp = False
            else: inter_file = arg
    init_run(input_file, inter_file, print_ast, comp)
    


def init_run(input_file, inter_file, print_ast, comp):
    parser = Parser()
    lines = ""
    try:
        with open(input_file) as file:
            lines = reduce(lambda a, b: a + b, file.readlines())
    except FileNotFoundError as e:
        print(e)
        return
    ast = parser.produce_AST(lines)
    print(f"successfully created AST from File {input_file}")
    if print_ast: 
        print("AST: ----------------------------")
        print(ast)
        print("---------------------------------")
    if comp:
        env = Env()
        code = ast.generate_code(env)
        print("successfully compiled into MIPS-Code")
        with open(inter_file, "w") as file:
            file.write(code)
        print(f"successfully created MIPS File {inter_file}")








if __name__ == "__main__":
    run_from_cmd()
