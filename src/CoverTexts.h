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

#ifndef COVERTEXTS_H
#define COVERTEXTS_H

#include <QObject>
#include <QString>


class CoverTexts : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString headerText READ getHeaderText NOTIFY headerTextChanged)
    Q_PROPERTY(QString waitingText READ getWaitingText NOTIFY waitingTextChanged)
    Q_PROPERTY(QString walkText READ getWalkText NOTIFY walkTextChanged)

    public:

        CoverTexts(QObject* parent = 0);
        ~CoverTexts(void);

        Q_INVOKABLE void initialize(void);

        Q_INVOKABLE QString getHeaderText(void) const;
        Q_INVOKABLE QString getWaitingText(void) const;
        Q_INVOKABLE QString getWalkText(void) const;

    signals:

        void headerTextChanged(QString);
        void waitingTextChanged(QString);
        void walkTextChanged(QString);

    private:

        CoverTexts(const CoverTexts&);
        CoverTexts& operator=(const CoverTexts&);

        QString m_headerText;
        QString m_waitingText;
        QString m_walkText;

};

#endif // COVERTEXTS_H
