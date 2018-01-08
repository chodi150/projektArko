#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

extern "C" float func(uchar* data, float x, float y, float s, float a, float b, float c);

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_drawButton_clicked();

private:
    Ui::MainWindow *ui;
    void drawCurves();
};

#endif // MAINWINDOW_H
