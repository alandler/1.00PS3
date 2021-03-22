import pandas as pd
import random
import names

random.seed()

df = pd.read_csv("books.csv")
data = df.sample(n=50)

genres = ["fantasy", "sci-fi", "mystery", "nonfiction", "autobiography"]

selected_costs = []
selected_isbns = []
selected_titles = []
selected_authors = []
selected_editors = []
selected_customers = []

instructions = ""
for i in range(len(data)): 
    # Access book information
    cost = random.randint(5, 30) + round(random.random(), 2)
    selected_costs.append(cost)
    selected_isbns.append(data["isbn13"].iloc[i])
    selected_titles.append(data["title"].iloc[i])
    b = "INSERT INTO `Books` VALUES ("
    b += "\'" + data["title"].iloc[i].replace("\'", "\\\'") + "\'" + ","
    b += data["isbn13"].iloc[i] + ","
    b += "\'" + data["publisher"].iloc[i].replace("\'", "\\\'") + "\'" + ","
    b += "\'" + random.choice(genres) + "\'," 
    b += str(cost) + "," 
    b += str(round((random.randint(5, 15) + random.random())/100, 4))
    b+= ")"
    instructions += b + ";\n"

    # Generate a random editor with probability p_none
    p_none = random.random()
    if p_none<=.5:
        # Either create new editor or use an existing one
        p_new = random.random()
        if p_new < .5 or len(selected_editors)==0:
            editor = names.get_full_name().replace("\'", "\\\'")
            if editor not in selected_editors:
                selected_editors.append(editor)
                editor_id = str(selected_editors.index(editor))
                editor = "\'" + editor + "\'"
                e = "INSERT INTO `Editors` VALUES (" + editor_id + "," + editor + ")"
                instructions += e + ";\n"
        else:
            editor = random.choice(selected_editors)
    else:
        editor_id = "NULL"
    ei = "INSERT INTO `BookEditors` VALUES (" + data["isbn13"].iloc[i] + "," + editor_id + ")"
    instructions += ei + ";\n"

    #Get the author data
    authors = (data["authors"].iloc[i]).split("/")
    for author in authors:
        if author not in selected_authors:
            selected_authors.append(author)
            author_id =  str(selected_authors.index(author))
            author = "\'" + author.replace("\'", "\\\'") + "\'"
            a = "INSERT INTO `Authors` VALUES (" + author_id+ "," + author + ")"
            instructions+= a + ";\n"
        ai = "INSERT INTO `BookAuthors` VALUES (" + data["isbn13"].iloc[i] + "," + author_id + ")"
        instructions+= ai + ";\n"

#Generate arbitrary Orders
for i in range(50):
    order_id = str(i)
    p_new_customer = .7
    if random.random() < p_new_customer or len(selected_customers)==0:
        customer_name = "\'" + names.get_full_name().replace("\'", "\\\'") + "\'"
        selected_customers.append(customer_name)
    else:
        customer_name= random.choice(selected_customers)
    isbn = random.choice(selected_isbns)
    copies = str(random.randint(1,3))
    c = "INSERT INTO `Orders` VALUES (" + order_id + "," + customer_name + "," + isbn + "," + copies + ");\n"
    instructions+= c

File_object = open("instructions.txt","w")
File_object.write(instructions)
File_object.close()

