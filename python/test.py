import threading

def test():
    i = 1
    while True:
        print(i)
        i += 1
    
t1 = threading.Thread(target = test)

t1.start()

while True:
    print(5)