with open('localities.txt', 'r') as localities, open('dartList.txt', 'w') as output:
  for locality in localities:
    locality = locality.strip('\n')
    if locality.startswith('//') or len(locality) == 0:
      continue
    output.write('"' + locality +'", ')
