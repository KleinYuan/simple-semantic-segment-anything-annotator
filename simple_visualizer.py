import json
import fire
import cv2
import numpy as np

def redraw(image_path, json_path, classes_to_keep):
    with open(json_path, 'r') as j:
        json_content = json.loads(j.read())
    annotations = json_content['annotations']
    filtered_items = {}
    for annotation in annotations:
        if annotation['class_name'] in classes_to_keep:
            bbox_xywh = annotation['bbox']
            x1 = bbox_xywh[0]
            y1 = bbox_xywh[1]
            x2 = bbox_xywh[0] + bbox_xywh[2]
            y2 = bbox_xywh[1] + bbox_xywh[3]
            score = annotation['stability_score']
            bbox_with_score = [x1, y1, x2, y2, score]
            if annotation['class_name'] not in filtered_items:
                filtered_items[annotation['class_name']] = [bbox_with_score]
            else:
                filtered_items[annotation['class_name']].append(bbox_with_score)
    display_mat = cv2.imread(image_path)
    color = (211, 63, 93)

    for class_name, bbox_with_score_list in filtered_items.items():
        for bbox_with_score in bbox_with_score_list:
            x1 = int(bbox_with_score[0])
            y1 = int(bbox_with_score[1])
            x2 = int(bbox_with_score[2])
            y2 = int(bbox_with_score[3])
            score = np.round(bbox_with_score[4], 2)
            cv2.rectangle(display_mat, (x1, y1), (x2, y2), color, 2)
            display_mat = cv2.rectangle(display_mat, (x1, y1 + 5), (x2, y1), color, -1)
            display_mat = cv2.putText(display_mat, f'{class_name[0]}-{score * 100}%', (x1, y1 + 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)

    cv2.imwrite(f'{json_path}.parsed.png', display_mat)


if __name__ == '__main__':
  fire.Fire()
