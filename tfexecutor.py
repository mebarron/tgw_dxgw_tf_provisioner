import os
import sys

session_name = 'tf-session'
t_chdir = 'terraform -chdir='

def tfdestroy(tfdirs):
    destroy_cmd = 'destroy -auto-approve'
    for tfdir in tfdirs: 
        try:
            os.system(t_chdir + tfdir + ' ' + destroy_cmd) 
        except Exception as tferror: 
            raise(tferror)

def tfinit(tfdirs): 
    init_cmd = 'init'
    for tfdir in tfdirs: 
        try:
            os.system(t_chdir + tfdir + ' ' + init_cmd)
        except Exception as tferror: 
            raise(tferror)

def tfapply(tfdirs):
    apply_cmd = 'apply -auto-approve'
    for tfdir in tfdirs:
        try:
            os.system(t_chdir + tfdir + ' ' + apply_cmd)
        except Exception as tferror:
            raise(tferror)

def main():
    tfdirs = []
    n = len(sys.argv)

    for i in range(1, n-1):
        tfdirs.append(sys.argv[i])
    
    if sys.argv[n-1] == 'destroy':
        tfdestroy(tfdirs)
    
    if sys.argv[n-1] == 'apply':
        tfinit(tfdirs)
        tfapply(tfdirs)

main()
