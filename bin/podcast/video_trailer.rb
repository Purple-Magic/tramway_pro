ffmpeg -loop 1 -i image.jpg -i trailer.mp3 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest trailer.mp4
