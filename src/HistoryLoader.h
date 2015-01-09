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

#ifndef HISTORYLOADER_H
#define HISTORYLOADER_H

#include "BaseLoader.h"
#include <QString>


class HistoryLoader : public BaseLoader
{
    Q_OBJECT

    public:

        HistoryLoader(QObject* parent = 0);
        ~HistoryLoader(void);

        Q_INVOKABLE void summarize(void);

        Q_INVOKABLE int today(void) const;
        Q_INVOKABLE QString getDayStr(const int dayIndex) const;
        Q_INVOKABLE QString getDateStr(const int dayIndex) const;
        Q_INVOKABLE int getWalkSum(const int dayIndex) const;
        Q_INVOKABLE QString getWalkTime(const int dayIndex, const int walkIndex) const;
        Q_INVOKABLE QString getWalkDuration(const int dayIndex, const int walkIndex) const;

    private:

        HistoryLoader(const HistoryLoader&);
        HistoryLoader& operator=(const HistoryLoader&);

        QString dayStr(const int dayOfWeek, const int dayIndex) const;
        QString walkTimeStr(const QTime& startTime, const QTime& endTime) const;
        QString durationStr(int duration) const;

};

#endif // HISTORYLOADER_H
