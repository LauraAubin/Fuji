# Fuji

## What does this application do?

Niceness modifies the scheduling priority of a given process which determines how much CPU time it receives. When you `increase` the niceness, it's priority `decreases`. The same goes for when you `decrease` the niceness, the priority will `increase`. This is helpful in scenarios such as giving a process more priority if it needs to perform faster. This is also helpful if you want to limit a process that would otherwise take up unnecessary CPU usage.

<br>

**This application allows a user to:**

- See how much CPU usage the selected process is using
- Determine if the process is "stable", "unstable" is defined as rapid fluctuations in CPU usage
- Allow the user to modify the "niceness" of the selected process
<br>

**The gif below demonstrates how the application works. In the background, I was using Photoshop to spike the CPU usage.**

<kbd>![Alt Text](https://github.com/LauraAubin/Fuji/blob/master/Demo/Fuji%20-%20April%2010%2C%202018.gif)</kbd><br>
<br><sup>(Note: This was recorded with LICEcap which distorted some of the colours)</sup><br>

<br>

## How can I run this application myself?

Make sure that you computer has the same (or similar) stats listed in the development section below. Note that this application was not tested on other computers, and does not guarantee that it will work on yours.

1. Download [`Fuji.app`](https://github.com/LauraAubin/Fuji/tree/master/Fuji%202018-04-10%2015-40-21/Fuji.app).

2. You need to run this file as the root user, so in a terminal type: `sudo Fuji.app/Contents/MacOS/Fuji`. This should launch the application automatically. The reason for this is explained [here.](https://github.com/LauraAubin/Fuji/pull/18)

The application runs on a 5 second timer, so you'll need to wait a few seconds for data to update.

<br>

## Development:

**Language:** Objective-C <br>
**Tools:** Xcode version 9.2 <br>
**Platform:** macOS High Sierra <br>
**Processor:** 2.5 GHz Intel Core i7 <br>

Note that this app has not been tested for cross platform compatibility.
 
See the [wiki](https://github.com/LauraAubin/Fuji/wiki) for a list of active system calls and resources.

<br>

## Implementation:

| Description | Completion goal  | Issue     | Completed    |
| ---------- |:---------:| ----:|-----:|
| Visualize running processes including the process name, PID, and NI  | March 12 | [#5](https://github.com/LauraAubin/Fuji/issues/5) | ✅  |
| Visualize individual process CPU values      |       March 16       |   [#6](https://github.com/LauraAubin/Fuji/issues/6)   | ✅ |
| Visualize CPU usage across the whole system      |       March 20       |   [#20](https://github.com/LauraAubin/Fuji/issues/20)  | ☑️ |
|  UI supports modifying NI    |  March 30  |   [#13](https://github.com/LauraAubin/Fuji/issues/13)  | ✅ |
|  Track CPU logic and fluctuating patterns    |  April 6  |  [#26](https://github.com/LauraAubin/Fuji/issues/26)  | ✅ |
|  CPU recommendations    | April 10  |  [#27](https://github.com/LauraAubin/Fuji/issues/27)  | ✅|

<br>

## Helpful pull requests:

**The following help explain how major tasks were completed:**

- [Connecting a controller to the UI](https://github.com/LauraAubin/Fuji/pull/9)
- [Using instance methods](https://github.com/LauraAubin/Fuji/pull/12)
- [Create a button](https://github.com/LauraAubin/Fuji/pull/14)
- [CPU usage for an individual process](https://github.com/LauraAubin/Fuji/pull/25)
- [How to run the application as root](https://github.com/LauraAubin/Fuji/pull/18)

<br>

## Acknowledgments :

This project was part of my COMP3000 Operating Systems class at Carleton. The project outline stated that we could "create anything that improves some aspect of an operating system."

🤪**Some silly goofs:**

As the project deadline approached, some corners needed to be cut in favour of finishing the application on time. These are some of them:

- The circles are actually made out of "O" letters, with increased boldness and font size
- The "cards" are actually just enlarged text fields
- You can freely resize the window, revealing a lot of empty space and a few unused text fields 🙈
