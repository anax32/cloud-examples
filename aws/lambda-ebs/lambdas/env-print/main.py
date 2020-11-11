import os

def handler(event, context):
  for k,v in os.environ.items():
    print("%s: %s" % (k, v))
  print("hi lol")
  print("mounts: '%s'" % open("/proc/mounts").read())
