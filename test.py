import cv2
def main(file_path):
    cap = cv2.cudacodec.createVideoReader(file_path)
    while True:
        ret, frame = cap.nextFrame()

        if ret is False:
            break
        print(frame)
if __name__ == '__main__':
    file_path = 'test.mov'
    main(file_path)
