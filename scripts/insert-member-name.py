import csv


SRC = 'member_profile.csv'
id_map = {}
with open(SRC, newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    next(reader)
    for row in reader:
        id_map[row[0]] = row[1]


SRC = 'frogmasterdata_observers.csv'
out = open('member-name.sql', 'w')

with open(SRC, newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter='\t')
    header = next(reader)
    #print(header)
    for row in reader:
        #print(row)
        ids = row[1]
        names = []
        for mid in ids.split(','):
            if x := id_map.get(mid, ''):
                names.append(x)
        sql = "INSERT INTO observer_member_rel (master_record_no, names) VALUES ({}, '{}');\n".format(row[0], ','.join(names))
        #print(sql)
        out.write(sql)

out.close()

