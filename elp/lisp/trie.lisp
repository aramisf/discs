; Definindo tamanho maximo para um vetor de caracteres:
(setq *MAXCHAR* 26)


; Estrutura basica da trie, que consiste em um inteiro e um vetor:
(defstruct st_trie
    qtde_filhos ; Conta a quantidade de filhos
    filhos      ; Filhos, um vetor de caracteres onde se pode iniciar outras
)                ; subtries



; Funcao que retorna o indice da letra passada como parametro, considera o
; caractere 'a' como o indice 0:
(defun indexador (letra)
    (- (char-code (char-downcase letra)) (char-code #\a))
)


; Adiciona uma palavra aa lista de palavras, caso ela ainda nao esteja inserida:
(defun adc_palavra (palavra st_trie)

    ; Se o tamanho da palavra for zero,
    (if (= (length palavra) 0)

        ; incrementa a qtde de filhos da trie
        (incf (st_trie-qtde_filhos st_trie))

        ; pega o 1o char, encontra o indice dele, e encontra o noh do vetor de
        ; caracteres correspondente.
        (let* ((letra (char palavra 0))
            (indice (indexador letra))
            (filho (aref (st_trie-filhos st_trie) indice)))

            ; Se o filho for vazio, cria um novo noh:
            (if (null filho)
                (setf (aref (st_trie-filhos st_trie) indice)
                      (make-st_trie :qtde_filhos 0 :filhos (make-array *MAXCHAR*)))
            )

            ; Chama a funcao recursivamente para o restante da palavra, caso o
            ; filho nao seja vazio
            (adc_palavra (substring palavra 1)
                (aref (st_trie-filhos st_trie) indice))

        ) ; let*
    ) ; if
)


; Retorna o ultimo noh da palavra, ou NIL, se a palavra nao for encontrada.
(defun encontra-palavra (palavra st_trie)
    (if (= (length palavra) 0)
        st_trie    ; Aqui retorna o noh;

        (let* ((letra (char palavra 0))
               (indice (indexador letra))
               (filho (aref (st_trie-filhos st_trie) indice)))

            (if (null filho)
                NIL   ; Retorna vazio se nao houver filho, ou chama a funcao
                      ; recursivamente para o resto da palavra
                (encontra-palavra (substring palavra 1) filho)
            )

        ) ; let*
    ) ; if
)


; Um contador de palavras:
(defun conta-palavra (palavra st_trie)

    ; Procura a palavra na trie, se o nodo for vazio, retorna zero, e a funcao
    ; acha-palavra retornara falso.
    (let ((nodo (encontra-palavra palavra st_trie)))
        (if (null nodo)
            0
            (st_trie-qtde_filhos nodo)
        )
    )
)


; Retorna T se a palavra for encontrada
(defun acha-palavra (palavra st_trie)
    (> (conta-palavra palavra st_trie) 0)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;  Segue a parte de substrings:  ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Buscando a substring:
(defun encontra-substr (substr st_trie)

    ; Se encontrar uma palavra no nodo atual, returna T
    (if (encontra-palavra substr st_trie)
        T

        ; Se nao, percorre o vetor dos filhos chamando a si mesma recursivamente
        (let ((resp NIL))
            (do ((i 0 (+ i 1)))
                ((or (= i *MAXCHAR*) resp) resp)
                (let ((filhos (aref (st_trie-filhos st_trie) i)))
                    (if filhos
                        (if (encontra-substr substr filhos)
                            (setf resp T)
                        )
                    )
                )
            ); do
        ); let
    ); if
)


; Uma vez encontrada uma substring que seja um prefixo de palavra, eh necessario
; listar todas as palavras onde tal prefixo foi encontrado. E eh isto que esta
; funcao faz.
(defun substr-prefix (substr st_trie)
    ; De inicio, nada foi encontrado
    (let ((resp NIL)
            (nodo (encontra-palavra substr st_trie)))

        ; Se algum nodo for encontrado, inclui ele na lista
        (if nodo
            (setf resp (cons nodo resp))
        )

        ; Percorre os filhos, e vai adicionando todos os 'sufixos' da subtrinng
        ; encontrada:
        (do ((i 0 (+ i 1)))
            ((= i *MAXCHAR*) resp)
            (let ((filho (aref (st_trie-filhos st_trie) i)))
                (if filho
                    (setf resp (append (substr-prefix substr filho) resp))
                )
            )
        )
    ); let
)


; Incrementador do contador de filhos por noh:
(defun incrementador (st_trie)
    (let ((sum (st_trie-qtde_filhos st_trie)))

        ; Percorre o vetor de letras, incrementando quando encontra um filho nao
        ; vazio
        (do ((i 0 (+ i 1)))
            ((= i *MAXCHAR*) sum)
            (let ((filho (aref (st_trie-filhos st_trie) i)))
                (if filho
                    (setf sum (+ sum (incrementador filho)))
                )
            )
        )
    )
)


; Encontra o total de ocorrencias para cada uma das substrings, depois soma
; todas elas, encontrando o total de ocorrencias em toda trie.
(defun calcula_total (substr st_trie)
    (apply #'+ (mapcar #'incrementador (substr-prefix substr st_trie)))
)


; Funcao que le as palavras de arquivo.
(defun leitor (arquivo)
    (let ((stream (open arquivo))

        ; Cria a estrutura inicial
        (st_trie (make-st_trie :qtde_filhos 0 :filhos (make-array *MAXCHAR*))))

        ; Ciclo para ler as palavras do arquivo
        (do ((palavra (read stream NIL "") (read stream NIL "")))
            ((string-equal palavra "") st_trie)
            (adc_palavra (symbol-name palavra) st_trie)
        )
    )
)

