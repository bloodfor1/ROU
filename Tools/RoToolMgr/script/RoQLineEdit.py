from PyQt5 import QtWidgets
class RoQLineEdit(QtWidgets.QLineEdit):
    """实现文件拖放功能"""

    def __init__(self,qWidget):
        super().__init__(qWidget)
        self.setAcceptDrops(True) # 设置接受拖放动作

    def dragEnterEvent(self, e):
        if e.mimeData().text().endswith('.json'): # 如果是.srt结尾的路径接受
            e.accept()
        else:
            e.ignore()

    def dropEvent(self, e): # 放下文件后的动作
        print(e.mimeData().text())
        path = e.mimeData().text().replace('file:///', '') # 删除多余开头
        self.setText(path)