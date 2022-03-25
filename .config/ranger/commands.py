# -*- coding: utf-8 -*-
# This file is for defining custom commands for ranger (mappings--ideally should--be set in the
# "rc.conf" file alongside the other mappings, but some main command names can be written here, then
# later shortened in the "rc.conf" file same as how ZSH aliasrc+functionrc files are
# organized/written).

####################################################################################################
########################################## Import Modules ##########################################
####################################################################################################
# (I believe this is to import some functions from Python3 to Python2 from what I briefly looked up
# online).
from __future__ import (absolute_import, division, print_function)

# Import the necessary ranger API python module.
from ranger.api.commands import *

# The import is needed so eval() can acces the ranger module.
import ranger                       # NOQA pylint: disable=unused-import,unused-variable


####################################################################################################
#################################### Begin Command Declarations ####################################
####################################################################################################

# Command to evaluate Python code.
class eval_(Command):
    """:eval [-q] <python code>

    Evaluates the python code.
    `fm' is a reference to the FM instance.
    To display text, use the function `p'.

    Examples:
    :eval fm
    :eval len(fm.directories)
    :eval p("Hellow World!")
    """
    name = 'eval'
    resolve_macros = False

    def execute(self):
        if self.arg(1) == '-q':
            code = self.rest(2)
            quiet = True
        else:
            code = self.rest(1)
            quiet = False
        global cmd, fm, p, quantifier       # pylint: disable=invalid-name,global-variable-undefined
        fm = self.fm
        cmd = self.fm.execute_console
        p = fm.notify
        quantifier = self.quantifier
        try:
            try:
                result = eval(code)         # pylint: disable=eval-used
            except SyntaxError:
                exec(code)                  # pylint: disable=exec-used
            else:
                if result and not quiet:
                    p(result)
        except Exception as err:            # pylint: disable=broad-except
            fm.notify("The error `%s` was caused by evaluating the following code: `%s`"
                    % (err, code), bad=True)


class newcmd(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify("Wrong number of arguments.", bad=True)
            return
        # First argument. 0 is the command name.
        self.fm.notify(self.arg(1))
        # Current directory to status line.
        self.fm.notify(self.fm.thisdir)
        # Run a shell command.
        self.fm.run(['touch', 'newfile'])




####################################################################################################
############################################# Testing. #############################################
####################################################################################################

class echo(Command):
    """:echo <text>

    Display the text in the statusbar.
    """
    def execute(self):
        self.notify(self.rest(1))
