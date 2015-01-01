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

#include "BaseLoader.h"
#include <QDateTime>


BaseLoader::BaseLoader(QObject* parent)
    : QObject(parent)
{
}

BaseLoader::~BaseLoader(void)
{
}

void BaseLoader::clearWalks(const int days)
{
    m_days.clear();

    QDate date = QDate::currentDate();

    for (int i = 0; i < days; ++i) {
        Day d;
        d.date = date;
        m_days.push_back(d);

        date = date.addDays(-1);
    }
}

void BaseLoader::addWalk(const int startTime, const int endTime, const int duration)
{
    QDateTime dateTime = QDateTime::fromTime_t(startTime);
    QDate date = dateTime.date();

    for (int i = 0; i < m_days.size(); ++i) {
        if (m_days.at(i).date == date) {
            Walk w;

            w.date = date;

            w.startTime = dateTime.time();

            dateTime = QDateTime::fromTime_t(endTime);
            w.endTime = dateTime.time();

            w.duration = duration;

            m_days[i].walks.push_back(w);

            return;
        }
    }
}
