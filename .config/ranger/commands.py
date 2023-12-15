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

# Command to open selected files in neovim each in their own neovim tab (command: `nvim -p "%@"`).
class vimtab(Command):
    """:vimtab
    Opens highlighted files in a neovim buffer with each selected file opened in its own tab.
    """

    allow_abbrev = False
    escape_macros_for_shell = True

    def execute(self):
        import shlex
        from functools import partial

        def is_directory_or_file(path):
            return os.path.isdir(path) and not os.path.islink(path) and len(os.listdir(path)) > 0

        if self.rest(1):
            file_names = shlex.split(self.rest(1))
            files = self.fm.get_filesystem_objects(file_names)
            if files is None:
                return
            many_files = (len(files) > 1 or is_directory_or_files(files[0].path))
        else:
            cwd = self.fm.thisdir
            tfile = self.fm.thisfile
            if not cwd or not tfile:
                self.fm.notify("Error: no files selected for editing...", bad=True)
                return

            files = self.fm.thistab.get_selection()
            # relative_path used for a user-friendly output in the confirmation.
            file_names = [f.relative_path for f in files]
            many_files = (cwd.marked_items or is_directory_or_file(tfile.path))     ### Change this.

    def tab(self, tabnum):
        return self._tab_directory_content()

    def _open_files_catch_arg_list_error(self, files):
        """
        Executes the fm.execute_file method but catches OSError ("Argument list too long")
        that occurs when moving too many files to trash (and would otherwise crash ranger)
        """
        try:
            self.fm.execute_file(files, label='trash')
        except OSError as err:
            if err.errno == 7:
                self.fm.notify("Error: Command too long (try passing less files at once)", bad=True)
            else:
                raise

####################################################################################################
############################################# Testing. #############################################
####################################################################################################

class echo(Command):
    """:echo <text>

    Display the text in the statusbar.
    """
    def execute(self):
        self.notify(self.rest(1))
