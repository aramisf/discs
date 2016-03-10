; Aqui abre-se o arquivo, seria ideal capturar como parametro, mas isso eh algo
; a se pensar.
(with-open-file (stream "/etc/passwd")

(setq npal 0) ; Definindo numero de palavra (eh um contador)

    ; o `do' faz uma repeticao de blocos de comando:
    (do
        ; Le uma linha e joga em `line', e enqto ler linha executar *bloco*.
        ((line (read-line stream nil) (read-line stream nil)))

        ; Parar quando a linha for vazia
        ((null line))

        ; *bloco* comeca aqui:
        (if (search "false" line) ; se encontrar a string "false" na linha atual,
            (progn      ; diz que vai executar mais de um comando, a rigor
                        ; deveria ser apenas um comando (quando nao usa o progn,
                        ; da erro.
                (setq npal (+ 1 npal)) ; soma 1 no contador;
                (print line)           ; imprime a linha
;                (print npal)           ; imprime o contador
            ) ; fecha o bloco de execucao

        ); fecha o parentesis do if

    ); final do `do'
        (print npal)

)
