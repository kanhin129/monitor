import sys
import websocket
try:
    import thread
except ImportError:
    import _thread as thread
import time

def on_message(ws, message):
    #print("receive: " + message)
    if message != None:
        print("ok")

def on_error(ws, error):
    print(error)

#def on_close(ws):
#    print("### closed ###")

def on_open(ws):
    def run(*args):
        for i in range(1):
            #time.sleep(1)
            #print("send: Hello %d" % i)
            ws.send("Hello %d" % i)
        time.sleep(2)
        ws.close()
        #print("thread terminating...")
    thread.start_new_thread(run, ())

if __name__ == "__main__":
    domain = sys.argv[1]
    #websocket.enableTrace(True)
    try:
        #ws = websocket.WebSocketApp(domain, on_message = on_message, on_error = on_error, on_close = on_close)
        ws = websocket.WebSocketApp(domain, on_message = on_message, on_error = on_error)
        ws.on_open = on_open
        ws.run_forever()

    except:
        print("Error")
