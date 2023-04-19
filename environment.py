from enum import Enum, auto

class VarError(Exception):
    pass

class Env():
    usedGlobalVarNames = {}
    gotoCounter = 0


    def deklGlobalVar(self, varname: str, init=None):
        if varname in self.usedGlobalVarNames:
            raise VarError("Variable name is already used")
        self.usedGlobalVarNames[varname] = init

    def useGlobalVar(self, varname: str):
        if varname not in self.usedGlobalVarNames:
            raise VarError("Variable is not declared yet")
        
    def getGoto(self):
        self.gotoCounter += 1
        return self.gotoCounter
    
    def generate_data(self):
        code = """
# Global Variables
        .data
        """
        for var in self.usedGlobalVarNames:
            value = self.usedGlobalVarNames[var]
            if value == None:
                code += f"""
        {var}: .space 4
                """
            else:
                code += f"""
        {var}: .word {value}
                """
        return code
