from enum import Enum, auto
from typing import List, Tuple, Dict

class VarError(Exception):
    pass

class TempEnv():
    usedLocalVarNames: Dict[str, int]

class Env():
    usedGlobalVarNames = {}
    tempEnvs = [TempEnv()]
    gotoCounter = 0
    in_func = False
    
    def deklLocalVar(self, varname:str, func_name:str):
        if varname in self.usedGlobalVarNames:
            raise VarError("Variable name is already globally used")
        local_var_names = []
        for temp in self.tempEnvs:
            for name in temp.usedLocalVarNames.keys():
                local_var_names += name
        if varname in local_var_names:
            raise VarError("Variable name is already locally used")
        self.tempEnvs[len(self.tempEnvs)-1].usedLocalVarNames[varname] = len(local_var_names)
        
    def getOffsetOfLocalVar(self, varname:str) -> int:
        local_vars = {}
        for temp in self.tempEnvs:
            local_vars += temp.usedLocalVarNames
        try:
            return local_vars[varname]
        except KeyError:
            raise VarError("Local Var not defined")

    def increase_depth(self):
        self.tempEnvs.append(TempEnv())

    def decrease_depth(self):
        self.tempEnvs.pop()

    def useVar(self, varname: str):
        if varname in self.usedGlobalVarNames:
            return
        return self.getOffsetOfLocalVar(varname)

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
