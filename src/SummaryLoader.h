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

#ifndef SUMMARYLOADER_H
#define SUMMARYLOADER_H

#include "BaseLoader.h"
#include <QString>


class SummaryLoader : public BaseLoader
{
    Q_OBJECT

    Q_PROPERTY(int activitySum READ getActivitySum NOTIFY activitySumChanged)
    Q_PROPERTY(int activityAvg READ getActivityAvg NOTIFY activityAvgChanged)
    Q_PROPERTY(int activityMin READ getActivityMin NOTIFY activityMinChanged)
    Q_PROPERTY(int activityMax READ getActivityMax NOTIFY activityMaxChanged)

    Q_PROPERTY(QString durationAvg READ getDurationAvg NOTIFY durationAvgChanged)
    Q_PROPERTY(QString durationMin READ getDurationMin NOTIFY durationMinChanged)
    Q_PROPERTY(QString durationMax READ getDurationMax NOTIFY durationMaxChanged)

    public:

        SummaryLoader(QObject* parent = 0);
        ~SummaryLoader(void);

        void summarize(void);

        Q_INVOKABLE int getActivitySum(void) const;
        Q_INVOKABLE int getActivityAvg(void) const;
        Q_INVOKABLE int getActivityMin(void) const;
        Q_INVOKABLE int getActivityMax(void) const;

        Q_INVOKABLE QString getDurationAvg(void) const;
        Q_INVOKABLE QString getDurationMin(void) const;
        Q_INVOKABLE QString getDurationMax(void) const;

    signals:

        void activitySumChanged(int);
        void activityAvgChanged(int);
        void activityMinChanged(int);
        void activityMaxChanged(int);

        void durationAvgChanged(QString);
        void durationMinChanged(QString);
        void durationMaxChanged(QString);

    private:

        SummaryLoader(const SummaryLoader&);
        SummaryLoader& operator=(const SummaryLoader&);

        QString getDurationString(int duration) const;

        int m_activitySum;
        int m_activityAvg;
        int m_activityMin;
        int m_activityMax;

        QString m_durationAvg;
        QString m_durationMin;
        QString m_durationMax;

};

#endif // SUMMARYLOADER_H
