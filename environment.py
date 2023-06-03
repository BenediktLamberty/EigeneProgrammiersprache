from enum import Enum, auto
from typing import List, Tuple, Dict

class VarError(Exception):
    pass



class Env():
    usedGlobalVarNames = {}
    tempEnvs = [{}]
    tempConsts = [set()]
    consts = set()
    args = set()
    gotoCounter = 0
    in_func = None
    max_offset = 0

    def startFunc(self, name:str, args:List[str]):
        self.in_func = name
        self.max_offset = 0
        self.args = set(args)
        self.tempEnvs = [{}]
        self.tempConsts = [set()]

    def endFunc(self):
        self.in_func = None
        self.max_offset = 0
        self.args = set()
        self.tempEnvs = [{}]
        self.tempConsts = [set()]

    
    def deklLocalVar(self, varname:str, const = False):
        if varname in self.usedGlobalVarNames:
            raise VarError("Variable name is already globally used")
        if varname in self.args:
            raise VarError("Variable name is already used as arg")
        local_var_names = set()
        for temp in self.tempEnvs:
            local_var_names.update(temp.keys())
        if varname in local_var_names:
            raise VarError("Variable name is already locally used")
        self.tempEnvs[len(self.tempEnvs)-1][varname] = len(local_var_names) + 1
        self.max_offset = max(self.max_offset, len(local_var_names) + 1)
        if const:
            self.tempConsts[len(self.tempConsts)-1].add(varname)
        
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
            raise VarError(f"Local Var {varname} not defined")

    def increase_depth(self):
        self.tempEnvs.append({})
        self.tempConsts.append(set())

    def decrease_depth(self):
        self.tempEnvs.pop()
        self.tempConsts.pop()

    def useVar(self, varname: str):
        if varname in self.usedGlobalVarNames:
            return None
        if varname in self.args:
            return "?" + varname
        return f"{self.getOffsetOfLocalVar(varname)}($fp)"
    
    def checkConst(self, varname: str):
        for lv in self.tempConsts:
            if varname in lv:
                raise VarError(f"Local Var {varname} const")
        if varname in self.consts:
            raise VarError(f"Global Var {varname} const")

    def deklGlobalVar(self, varname: str, init=None, const=False):
        if varname in self.usedGlobalVarNames:
            raise VarError("Variable name is already used")
        self.usedGlobalVarNames[varname] = init
        if const:
            self.consts.add(varname)

    def useGlobalVar(self, varname: str):
        if varname not in self.usedGlobalVarNames:
            msg = f"Variable {varname} is not declared yet"
            raise VarError(msg)
        
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
