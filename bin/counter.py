#!/usr/bin/env python3

import os
import sys
import time
import datetime
import signal

# global flag to stop the daemon gracefully
stop_daemon = False
outfile = None

def format_output_line(name, counter, now=None):
    # return formatted output line using the given name, counter, and time
    if now is None:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"{name}: {now} #{counter}"

def signal_handle(signum, frame):
    # handles termination signals
    # when sigterm is received it writes a message to the file and flushes stdout and then exits
    global stop_daemon, outfile
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    message = f"Cooper: {now} Recieved SIGTERM, exiting"

    # if output file is open, write message and flush
    if outfile is not None:
        outfile.write(message + "\n")
        outfile.flush()

    # print message to stdout
    print(message, flush = True)

    # set the stop flag
    stop_daemon = True
    sys.exit(0)

def main():
    global stop_daemon, outfile

    # registar signal handlers for sigterm and sigint
    signal.signal(signal.SIGTERM, signal_handle)
    signal.signal(signal.SIGINT, signal_handle)

    outfile_path = "/tmp/currentCount.out"
    try:
        # open output file in write mode
        outfile = open(outfile_path, "w")
    except Exception as e:
        sys.stderr.write(f"Could not open file {outfile_path}: {e}\n")
        sys.exit(1)

    counter = 0
    name = "Cooper"

    # main loop, runs until termination signal is received
    while not stop_daemon:
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        output_line = f"{name}: {now} #{counter}"

        # print to stdout
        print(output_line, flush = True)
        
        # write to file
        outfile.write(output_line + "\n")
        outfile.flush()

        counter += 1
        time.sleep(1)

    outfile.close()

if __name__ == "__main__":
    main()