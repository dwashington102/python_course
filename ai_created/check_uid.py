#!/usr/bin/env python3
import platform
import os
import ctypes
import getpass

def check_user_privileges():
    """
    Check if the current user is 'root' on Linux or has admin privileges on Windows.
    Returns:
        str: Description of the user privilege status.
    """
    os_name = platform.system()
    current_user = getpass.getuser()
    
    if os_name == 'Linux':
        if current_user == 'root':
            return f"User '{current_user}' has root privileges on Linux."
        else:
            return f"User '{current_user}' does not have root privileges on Linux."
    elif os_name == 'Windows':
        try:
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
            if is_admin:
                return f"User '{current_user}' has administrative privileges on Windows."
            else:
                return f"User '{current_user}' does not have administrative privileges on Windows."
        except AttributeError:
            return "Error: Unable to check admin privileges on Windows. 'ctypes.windll' not available."
    else:
        return f"Operating System '{os_name}' is not supported for privilege checking."

# Example usage
if __name__ == '__main__':
    result = check_user_privileges()
    print(result)
