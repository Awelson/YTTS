# YTTS

YouTube Time Stamps (YTTS) is a javascript + CSS which allows one to add timestamp links + subtitles onto embedded YouTube videos on your website.

## Requirements

- The [YouTube iframe API](https://www.youtube.com/iframe_api)
  - e.g. include `<script src="https://www.youtube.com/iframe_api"></script>` in your HTML
 
## Example Implementation

[A minimal implementation on JSbin](https://jsbin.com/jegobovije/1/edit?html,output)

## Usage

Of course, no one wants to write down all of that HTML by hand, so I have also made an HTML compiler with Haskell which you download here, or build it directly from the source code.

- In the same folder as YTTS.exe, create three new text files and name them TimePoints.txt, TimeStamps.txt, and YouTube.txt
- In YouTube.txt, add a link to the YouTube video
- In TimeStamps.txt, add (line by line) the time (in seconds) where you want the anchor to link to, followed by the anchor text 
- In TimePoints.txt, add (line by line) the time (in seconds) where you want the subtitles to appear, followed by the subtitle text
- Tun YTTS.exe

For example :

```YouTube.txt
# YouTube.txt

https://www.youtube.com/watch?v=F0dVRVukd4U
```

```TimeStamps.txt
# TimeStamps.txt

9.5, 踊る # use decimals for more precision!
23, ノルマ
```

```TimePoints.txt
# TimePoints.txt

5, hello
```

and running YTTS.exe will create

```New.txt
# New.txt

<div id="player" data-video-id="F0dVRVukd4U" data-time-points='[{"time":5,"text":"hello"}]'></div>
<div id="text-display" align="center"> </div>
<div id="timestamps" markdown>
<div class="timestamp" data-time="9.5"><h3>踊る</h3></div>
<div class="timestamp" data-time="23"><h3>ノルマ</h3></div>
</div>
```

## Make subtitles dissappear

```TimePoints.txt
# TimePoints.txt

# .. subtitles before ..
32, hello
# .. subtitles after ..
```

Will make "Hello" appear at second 32 but it will stay there until it is time for the next subtitle to appear (or until the video ends if there is no "next subtitle"). This can be troublesome if there is a long silence after "Hello". If you want to make "Hello" dissappear after, say, 5 seconds, then simply add `37, ` to the next line.

```TimePoints.txt
# TimePoints.txt

# .. subtitles before ..
32, hello
37, 
# .. subtitles after ..
```

## Multi-line subtitles

use `\n` to make multi-line subtitles

```TimePoints.txt
# TimePoints.txt

# .. subtitles before ..
32, hello \n HELLO again
# .. subtitles after ..
```

## Parsing quotations (and other special symbols)

To parse quotations (" ") you have to use `\"`

```TimePoints.txt
# TimePoints.txt

# .. subtitles before ..
32, \"Hello\"
# .. subtitles after ..
```

## That is pretty much it..

You can be creative with however you want to use YTTS. For example, instead of subtitles you can add comments/notes and make them appear at a particular timepoint in a video, etc...

In my case, I use it to create [annotated Japanese YouTube videos](https://awelson.github.io/Blog/Japanese%20Section%20🗾/Annotated/) for learning purposes. 

