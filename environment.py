from enum import Enum, auto
from typing import List, Tuple, Dict

class VarError(Exception):
    pass



class Env():
    usedGlobalVarNames = {}
    tempEnvs = [{}]
    args = set()
    gotoCounter = 0
    in_func = None
    max_offset = 0

    def startFunc(self, name:str):
        self.in_func = name
        self.max_offset = 0
        self.args = set()
        self.tempEnvs = [{}]

    def endFunc(self):
        self.in_func = None
        self.max_offset = 0
        self.args = set()
        self.tempEnvs = [{}]

    
    def deklLocalVar(self, varname:str):
        if varname in self.usedGlobalVarNames:
            raise VarError("Variable name is already globally used")
        if varname in self.args:
            raise VarError("Variable name is already used as arg")
        local_var_names = set()
        for temp in self.tempEnvs:
            local_var_names.update(temp.keys())
        if varname in local_var_names:
            raise VarError("Variable name is already locally used")
        print(local_var_names)
        self.tempEnvs[len(self.tempEnvs)-1][varname] = len(local_var_names) + 1
        self.max_offset = max(self.max_offset, len(local_var_names) + 1)
        a = 0
        print(a)
        #print(f"decl of {varname} at reg offset {len(local_var_names)}")
        
    def checkArgs(self, args: List[str]):
        for arg in args:
            if arg in self.usedGlobalVarNames:
                raise VarError("Arg already used as global var")
            self.args.add(arg)

    def getOffsetOfLocalVar(self, varname:str) -> int:
        local_vars = {}
        for temp in self.tempEnvs:
            local_vars.update(temp)
        try:
            return local_vars[varname] * 4 + 32
        except KeyError:
            raise VarError("Local Var not defined")

    def increase_depth(self):
        self.tempEnvs.append({})

    def decrease_depth(self):
        self.tempEnvs.pop()

    def useVar(self, varname: str):
        if varname in self.usedGlobalVarNames:
            return None
        if varname in self.args:
            return "?" + varname
        return f"{self.getOffsetOfLocalVar(varname)}($fp)"

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
