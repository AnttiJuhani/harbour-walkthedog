/*
 * Copyright (C) 2015 Antti Aura
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the author nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "WalkTimer.h"
#include <QTimer>
#include <QDateTime>


WalkTimer::WalkTimer(QObject* parent)
    : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(update()));
    initialize(0);
}

WalkTimer::~WalkTimer(void)
{
    delete m_timer, m_timer = 0;
}

void WalkTimer::initialize(const int waitingTime)
{
    m_isWalking = false;
    emit isWalkingChanged(m_isWalking);

    m_waitingStart = waitingTime;

    m_walkStart = 0;
    m_walkEnd = 0;
    m_walkDuration = 0;

    m_duration = 0;

    m_walkEndStr = walkEndStr(m_waitingStart);
    emit walkEndTextChanged(m_walkEndStr);

    update();
}

bool WalkTimer::isWalking(void) const
{
    return m_isWalking;
}

QString WalkTimer::getDuration(void) const
{
    return m_durationStr;
}

void WalkTimer::startWalk(void)
{
    m_isWalking = true;
    emit isWalkingChanged(m_isWalking);
    m_walkStart = QDateTime::currentDateTime().toTime_t();
    startTimer();
}

void WalkTimer::stopWalk(void)
{
    m_isWalking = false;
    emit isWalkingChanged(m_isWalking);
}

void WalkTimer::finishWalk(void)
{
    stopWalk();
    m_walkEnd = QDateTime::currentDateTime().toTime_t();
    m_waitingStart = m_walkEnd;
    m_walkDuration = m_walkEnd-m_walkStart;

    m_walkEndStr = walkEndStr(m_waitingStart);
    emit walkEndTextChanged(m_walkEndStr);
}

int WalkTimer::getWalkLenght(void) const
{
    return m_walkDuration;
}

int WalkTimer::getWalkStart(void) const
{
    return m_walkStart;
}

int WalkTimer::getWalkEnd(void) const
{
    return m_walkEnd;
}

QString WalkTimer::getWalkEndText(void) const
{
    return m_walkEndStr;
}

void WalkTimer::startTimer(void)
{
    update();
    m_timer->start(1000);
}

void WalkTimer::stopTimer(void)
{
    m_timer->stop();
}

void WalkTimer::update(void)
{
    int timeNow = QDateTime::currentDateTime().toTime_t();

    int diff = -1;
    if (m_isWalking && m_walkStart > 0) {
        diff = timeNow-m_walkStart;
    }
    else if (!m_isWalking && m_waitingStart > 0) {
        diff = timeNow-m_waitingStart;
    }

    m_durationStr = durarationStr(diff);
    emit durationChanged(m_durationStr);

    if (diff < 0) {
        stopTimer();
    }
    else if (diff >= 86400) {
        stopTimer();
    }
}

QString WalkTimer::durarationStr(int diff) const
{
    if (diff < 0) {
        return tr("Not available");
    }
    if (diff >= 86400) {
        return tr("More than a day");
    }

    int hours = diff/3600;
    diff = diff%3600;

    int minutes = diff/60;
    diff = diff%60;

    int seconds = diff;

    QTime s;
    s.setHMS(hours, minutes, seconds);
    return s.toString();
}

QString WalkTimer::walkEndStr(int timeStamp) const
{
    if (timeStamp == 0) {
        return tr("No available");
    }
    
    QString str = QDateTime::fromTime_t(timeStamp).toString("dd.MM.yyyy hh:mm:ss");
    return str;
}
