#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtWidgets>
#include <iostream>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    ui->Aspinbox->setRange(-5.0, 5.0);

    ui->Aspinbox->setSingleStep(0.1);
    ui->Aspinbox->setDecimals(1);
    ui->Aspinbox->setValue(0.5);


    ui->Bspinbox->setRange(-20.0, 20.0);

    ui->Bspinbox->setSingleStep(0.1);
    ui->Bspinbox->setDecimals(1);
    ui->Cspinbox->setRange(-100.0, 100.0);

    ui->Cspinbox->setSingleStep(0.1);
    ui->Cspinbox->setDecimals(1);
  //  ui->Cspinbox->setValue(-3);
    ui->widthspinbox->setRange(-100,100);
    ui->widthspinbox->setValue(3);
    ui->heightspinbox->setRange(-100,100);
    ui->heightspinbox->setValue(3);
    ui->Sspinbox->setRange(-1, 1);

    ui->Sspinbox->setSingleStep(0.001);
    ui->Sspinbox->setDecimals(3);
    ui->Sspinbox->setValue(0.03);
  // drawCurves();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_drawButton_clicked()
{
    drawCurves();

}

void MainWindow::drawCurves()
{
    uchar data[786486];

    for(int i=0; i<786486; i++)
    {
        data[i] = 0x00;
    }
    for(int i =0; i<512; i++)
    {
        data[i*1536 + 54 + 256*3]=255;
    }
    for(int i = 0; i<512; i++)
        data[512*3*256+3*i]=255;
    data[0] = 0x42;
    data[1] = 0x4d;
    data[2] = 0x36;
    data[4] = 0x0c;
    data[10] = 0x36;
    data[14] = 0x28;
    data[19] = 0x02;
    data[23] = 0x02;
    data[26] = 0x01;
    data[28] = 0x18;
    data[36] = 0x0c;
    qDebug() << func(data+54, ui->widthspinbox->value(), ui->heightspinbox->value(), ui->Sspinbox->value(), ui->Aspinbox->value(), ui->Bspinbox->value(), ui->Cspinbox->value());
    QPixmap *pixmap = new QPixmap();
    pixmap->loadFromData(data, 786486);
    ui->label->setPixmap(*pixmap);
}
