/*
 * Copyright (C) 2014 Antti Aura
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

#include "HistoryLoader.h"
#include <QDateTime>


HistoryLoader::HistoryLoader(QObject* parent)
    : BaseLoader(parent)
{
}

HistoryLoader::~HistoryLoader(void)
{
}

void HistoryLoader::summarize(void)
{
}

int HistoryLoader::today(void) const
{
    QDateTime dateTime;
    dateTime.setDate( QDate::currentDate() );
    dateTime.setTime( QTime(0,0) );
    return dateTime.toTime_t();
}

QString HistoryLoader::getDayStr(const int dayIndex) const
{
    if (dayIndex >= 0 && dayIndex < m_days.size()) {
        int dayOfWeek = m_days.at(dayIndex).date.dayOfWeek();
        return dayStr(dayOfWeek, dayIndex);
    }
    return QString("");
}

QString HistoryLoader::getDateStr(const int dayIndex) const
{
    if (dayIndex >= 0 && dayIndex < m_days.size()) {
        return m_days.at(dayIndex).date.toString("dd/MM");
    }
    return QString("");
}

int HistoryLoader::getWalkSum(const int dayIndex) const
{
    if (dayIndex >= 0 && dayIndex < m_days.size()) {
        return m_days.at(dayIndex).walks.size();
    }
    return 0;
}

QString HistoryLoader::getWalkTime(const int dayIndex, const int walkIndex) const
{
    if (dayIndex >= 0 && dayIndex < m_days.size()) {
        if (walkIndex >= 0 && walkIndex < m_days.at(dayIndex).walks.size()) {
            QTime startTime = m_days.at(dayIndex).walks.at(walkIndex).startTime;
            QTime endTime = m_days.at(dayIndex).walks.at(walkIndex).endTime;
            return walkTimeStr(startTime, endTime);
        }
    }
    return QString("");
}

QString HistoryLoader::getWalkDuration(const int dayIndex, const int walkIndex) const
{
    if (dayIndex >= 0 && dayIndex < m_days.size()) {
        if (walkIndex >= 0 && walkIndex < m_days.at(dayIndex).walks.size()) {
            return durationStr( m_days.at(dayIndex).walks.at(walkIndex).duration );
        }
    }
    return "";
}

QString HistoryLoader::dayStr(const int dayOfWeek, const int dayIndex) const
{
    if (dayIndex == 0) {
        return tr("Today");
    }
    else if (dayIndex == 1) {
        return tr("Yesterday");
    }
    switch (dayOfWeek) {
        case 1: return tr("Monday");
        case 2: return tr("Tuesday");
        case 3: return tr("Wednesday");
        case 4: return tr("Thursday");
        case 5: return tr("Friday");
        case 6: return tr("Saturday");
        case 7: return tr("Sunday");
        default: return QString("");
    }
}

QString HistoryLoader::walkTimeStr(const QTime& startTime, const QTime& endTime) const
{
    return QString("%1 - %4").arg( startTime.toString("hh:mm") ).arg( endTime.toString("hh:mm") );
}

QString HistoryLoader::durationStr(int duration) const
{
    int hours = duration / 3600;
    duration = duration%3600;
    int minutes = duration / 60;
    duration = duration%60;
    int seconds = duration;

    if (hours == 0 && minutes == 0) {
        return tr("%1sec").arg(seconds);
    }

    QString str("");
    if (hours > 0) {
        str = tr("%1h ").arg(hours);
    }
    str.append( tr("%1min").arg(minutes) );
    return str;
}
