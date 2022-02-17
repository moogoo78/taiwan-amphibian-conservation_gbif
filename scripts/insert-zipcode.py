import json

data = open('zipcode.json')
out = open('zipcode_citytown.sql', 'w')

zipcode_map = {}
d = data.read()
#print(d)
for i in json.loads(d):
    for city, towns in i.items():
        for town in towns:
            for name in town:
                zipcode = town[name]
                zipcode_map[zipcode] = f'{city} {name}'

#print(zipcode_map)
for k,v in zipcode_map.items():
    sql = "INSERT INTO zipcode_citytown (zipcode, name) VALUES('{}', '{}');\n".format(k, v)
    out.write(sql)

out.close()
