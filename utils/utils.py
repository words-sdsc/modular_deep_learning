import sys
import glob
import xml.etree.ElementTree as et
import pandas as pd

DIR = '../'
profile_files = ["profile.0.0.0"]
#if len(sys.argv < 2): 
#  profile_files = glob.glob(DIR + "profile.[0-9].*")
#else:
#  profile_files = [glob.glob()]

def parse_profiles(profiles):
    profile_dataframes = []
    for pf in profile_files:
        print('reading: '+pf)
        with open(pf) as f:
            profile = f.read().splitlines() 
            templated_function_num = profile.pop(0)
            l1 = profile.pop(0)
            metadata = l1[l1.find("<metadata>"):l1.find("</metadata>")+11]
            header = l1[:l1.find("<metadata>")]
            header = [w.strip() for w in header.translate(None,"#").split()]

            dfs = []
            data = []
            for i,line in enumerate(profile):
                # check for new section
                if line[0] == '#': 
                    dfs.append(pd.DataFrame(data,columns=header))
                    data = []
                    # get new header
                    header = [w.strip() for w in line.translate(None, "#").split()]
                elif line[0] == '\"':
                    l = line.strip().split("\" ")[0:]
                    eventName = l[0].translate(None,"\"")
                    etc = l[1].split()
                    row = [eventName] + etc
                    row = [r for r in row if 'GROUP' not in r]
                    data.append(row)
                else:
                    print('[LOG] skipping line: ' + str(i))
                    continue
            dfs.append(pd.DataFrame(data,columns=header))
        profile_dataframes.append((metadata,dfs)) 
    if len(profile_dataframes) > 1:
        return profile_dataframes
    else:
        return profile_dataframes[0]