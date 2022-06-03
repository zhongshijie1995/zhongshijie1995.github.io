import os

file_path = []
fileDir = "source/_posts"


def func():
    for root, dirs, files in os.walk(fileDir):
        for file_item in files:
            file_path.append('{}/{}'.format(root, file_item))


def alter(file, old_str, new_str):
    file_data = ""
    with open(file, "r", encoding='utf-8') as f:
        for line in f:
            if old_str in line:
                line = line.replace(old_str, new_str)
            file_data += line
    with open(file, "w", encoding='utf-8') as f:
        f.write(file_data)


if __name__ == "__main__":
    func()
    for item in file_path:
        alter(item, "D:/01-Project/Blog/mirrors-pic/img/", "https://zhongshijie1995.github.io/zhongshijie-pic/img/")
        alter(item, "img/", "https://zhongshijie1995.github.io/zhongshijie-pic/img/")
