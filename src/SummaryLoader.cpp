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

#include "SummaryLoader.h"


SummaryLoader::SummaryLoader(QObject* parent)
    : BaseLoader(parent)
{
}

SummaryLoader::~SummaryLoader(void)
{
}

void SummaryLoader::summarize(void)
{
    m_activitySum = 0;
    m_activityAvg = 0;
    m_activityMin = 999;
    m_activityMax = 0;

    int durationAvg = 0;
    int durationMin = 99999;
    int durationMax = 0;

    foreach(Day d, m_days) {
        int numOfWalks = d.walks.size();

        m_activitySum += numOfWalks;

        if (numOfWalks > m_activityMax) {
            m_activityMax = numOfWalks;
        }
        if (numOfWalks < m_activityMin) {
            m_activityMin = numOfWalks;
        }

        foreach(Walk w, d.walks) {
            int duration = w.duration;

            durationAvg += duration;

            if (duration > durationMax) {
                durationMax = duration;
            }
            if (duration < durationMin) {
                durationMin = duration;
            }
        }
    }

    if (m_activitySum > 0) {
        m_activityAvg = static_cast<int>(1.0*m_activitySum/m_days.size() + 0.5 );

        durationAvg /= m_activitySum;
        m_durationAvg = getDurationString(durationAvg);
        m_durationMin = getDurationString(durationMin);
        m_durationMax = getDurationString(durationMax);
    }
    else {
        m_activityMin = 0;

        m_durationAvg = tr("<missing>");
        m_durationMin = m_durationAvg;
        m_durationMax = m_durationAvg;
    }

    emit activitySumChanged(m_activitySum);
    emit activityAvgChanged(m_activityAvg);
    emit activityMinChanged(m_activityMin);
    emit activityMaxChanged(m_activityMax);

    emit durationAvgChanged(m_durationAvg);
    emit durationMinChanged(m_durationMin);
    emit durationMaxChanged(m_durationMax);
}

int SummaryLoader::getActivitySum(void) const
{
    return m_activitySum;
}

int SummaryLoader::getActivityAvg(void) const
{
    return m_activityAvg;
}

int SummaryLoader::getActivityMin(void) const
{
    return m_activityMin;
}

int SummaryLoader::getActivityMax(void) const
{
    return m_activityMax;
}

QString SummaryLoader::getDurationAvg(void) const
{
    return m_durationAvg;
}

QString SummaryLoader::getDurationMin(void) const
{
    return m_durationMin;
}

QString SummaryLoader::getDurationMax(void) const
{
    return m_durationMax;
}

QString SummaryLoader::getDurationString(int duration) const
{
    int hours = duration / 3600;
    duration = duration % 3600;
    int minutes = duration / 60;
    duration = duration%60;
    int seconds = duration;

    if (hours == 0 && minutes == 0) {
        return tr("%1sec").arg(seconds);
    }

    if (hours == 0) {
        return tr("%1min").arg(minutes);
    }
    else {
        return tr("%1h %2min").arg(hours).arg(minutes);
    }
}
