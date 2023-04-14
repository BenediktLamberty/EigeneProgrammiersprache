import myParser





def main():
    parser = myParser.Parser()

    while True:
        inp = input(">>> ")
        if (inp == None) or ("exit" in inp) or (inp == ""):
            exit(1)
        
        program = parser.produce_AST(inp)
        print(program)
    


if __name__ == "__main__":
    main()