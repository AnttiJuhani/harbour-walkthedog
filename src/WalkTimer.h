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

#ifndef WALKTIMER_H
#define WALKTIMER_H

#include <QObject>
#include <QString>

class QTimer;


class WalkTimer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool walking READ isWalking NOTIFY isWalkingChanged)
    Q_PROPERTY(QString duration READ getDuration NOTIFY durationChanged)
    Q_PROPERTY(QString walkEndText READ getWalkEndText NOTIFY walkEndTextChanged)

    public:

        WalkTimer(QObject* parent = 0);
        ~WalkTimer(void);

        Q_INVOKABLE void initialize(const int waitingTime);

        Q_INVOKABLE bool isWalking(void) const;
        Q_INVOKABLE QString getDuration(void) const;

        Q_INVOKABLE void startWalk(void);
        Q_INVOKABLE void stopWalk(void);
        Q_INVOKABLE void finishWalk(void);
        Q_INVOKABLE int getWalkLenght(void) const;
        Q_INVOKABLE int getWalkStart(void) const;
        Q_INVOKABLE int getWalkEnd(void) const;
        Q_INVOKABLE QString getWalkEndText(void) const;

        Q_INVOKABLE void startTimer(void);
        Q_INVOKABLE void stopTimer(void);

        Q_INVOKABLE void updateWalkEndText(void);

    public slots:

        void update(void);

    signals:

        void isWalkingChanged(bool);
        void durationChanged(QString);
        void walkEndTextChanged(QString);

    private:

        WalkTimer(const WalkTimer&);
        WalkTimer& operator=(const WalkTimer&);

        QString durarationStr(int diff) const;
        QString walkEndStr(int timeStamp) const;

        QTimer* m_timer;

        bool m_isWalking;
        int m_waitingStart;

        int m_walkStart;
        int m_walkEnd;
        int m_walkDuration;

        int m_duration;
        QString m_durationStr;
        QString m_walkEndStr;        

};

#endif // WALKTIMER_H
