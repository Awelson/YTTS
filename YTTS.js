let player;

function onYouTubeIframeAPIReady() {
    const playerElement = document.getElementById('player');
    const videoId = playerElement.getAttribute('data-video-id');
    const timePoints = JSON.parse(playerElement.getAttribute('data-time-points'));

    player = new YT.Player('player', {
        height: '360',
        width: '640',
        videoId: videoId,
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });

    function onPlayerReady(event) {
        event.target.playVideo();
        setupTimestamps(timePoints);
    }

    function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.PLAYING) {
            setInterval(() => checkTime(timePoints), 100); // Check the video time every 100ms
        }
    }

    function checkTime(timePoints) {
        let currentTime = player.getCurrentTime();
        for (let i = 0; i < timePoints.length; i++) {
            let startTime = timePoints[i].time;
            let endTime = i < timePoints.length - 1 ? timePoints[i + 1].time : player.getDuration();

            if (currentTime >= startTime && currentTime < endTime) {
                document.getElementById('text-display').innerText = timePoints[i].text;
                break;
            }
        }
    }

    function setupTimestamps(timePoints) {
        let timestampElements = document.querySelectorAll('.timestamp');
        timestampElements.forEach(el => {
            el.onclick = () => {
                let time = parseFloat(el.getAttribute('data-time'));
                player.seekTo(time, true); // Seek accurately to the specified time
            };
        });
    }
}