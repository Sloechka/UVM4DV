# Лабораторная работа 7 "UVM: Layering и регистровая модель"


## Цель

Познакомиться с концепциями формирования многоуровневых тестовых воздействий в UVM (layering). Научиться применять генерацию последовательнстей с использованием генерации на нескольких уровнях
Познакомиться с концепциями формирования многоуровневых тестовых воздействий в UVM

## Основные обозначения

|Так выделяется важная информация, на которой стоит заострить внимание|
|:---|

```verilog
Так выделяется разбор примеров.
```

`Так выделяются определения, и ключевые слова SystemVerilog.`

---
## Теория

TODO
Когда-нибудь тут будет стена текста


---

## Ход работы

#### Шаг 0. Познакомиться с описанием устройства

##### Назначение устройства

Устройство ассоциативной памяти на 4 записи с режимом поиска по индексу и по данным.
Управлени по интерфейсу DSTREAM, не поддерживающиму явную адресацию


##### Интерфейс DSTREAM

Синхронный дуплексный интерфейс. Данные от ведущего и от ведомого устройства передаются одновлеменно в одном такте, если установлен сигнал valid

|имя сигнала|разрядность|назначение|
|---|---|---|
|clk|[0:0]|тактовый сигнал (работа по переднему фронту)|
|rst_n|[0:0]|сброс, активный низкий уровень|
|d_valid|[0:0]|индикация выполняющейся транзакции|
|d_master|[31:0]|данные от ведущего устройства|
|d_slave|[31:0]|данные от ведомого устройства|


```bash
┌Signals────────┐┌Waves─────────────────────────────────┐
|clk            ││┌───┐   ┌───┐   ┌───┐   ┌───┐   ┌───┐ │
│               ││    └───┘   └───┘   └───┘   └───┘   └─│
│valid          ││        ┌───────┐       ┌───────┐     │
│               ││────────┘       └───────┘       └─────│
│               ││────────┬───────┬───────┬───────┬─────│
│d_master       ││ xx     │mdata0 │xx     │mdata1 │ xx  │
│               ││────────┴───────┴───────┴───────┴─────│
│               ││────────┬───────┬───────┬───────┬─────│
│d_slave        ││ xx     │sdata0 │xx     │sdata1 │ xx  │
│               ││────────┴───────┴───────┴───────┴─────│
│               ││                                      │
└───────────────┘└──────────────────────────────────────┘
```

DUT является ведомым устройством


##### Уровнеь A-LYAER

Интерфейс передачи данных с поддержкой адресации и транзакций чтения и записи.
Уровень с поддержкой адресации реализуется поверх интерфейса DSTREAM.
Каждая транзакцйия уровня A_LAYER преобразуется в две транзакеции уровня DSTREAM.

транзакция A_LAYER
|имя поля|разрядность|назначение|
|---|---|---|
|data|32|данные|
|addr|24|адрес транзакции|
|tran_type|1|тип транзакции 0 - чтение, 1 - запись|

Переход на уровнеь DSTREAM

Транзакция чтения:
|номер DSTREAM транзакци|поля|
|---|---|
|0|d_master[31:24] = 0, d_master[23:0] = addr, d_slave не важны|
|1|data = d_slave, d_master не важны|

Транзакция записи:
|номер DSTREAM транзакци|поля|
|---|---|
|0|d_master[31:24] = 1, d_master[23:0] = addr, d_slave не важны|
|1|d_master = data, d_slave не важны|

В тестируемом устройстве раализована поддержка уровня A_LAYER для поддержки операции записи и чтения регистров.


##### Описание регистров устройства

###### регистры
|имя регистра|режим доступа|адрес|назначение|
|---|---|---|---|
|ctrl|RW|0x1000|регистр управления|
|valid|R|0x1004|регистр валидности записей в ячейках памяти|
|search_reg|RW|0x1008|регистр, содержащий запрос на поиск|
|result_reg|R|0x100c|регистр, содержащий результат поиска|
|cam_mem|RW|0x2000-0x200c|ячейки памяти|

###### поля регистра ctrl

|имя поля|режим доступа|смещение|значение по сбросу|назначение|
|---|---|---|---|---|
|mode|RW|[1:0]|0x0|задает режим работы поиска. <br> mode = `0x00` - result_reg хранит последнее найденное значение вне зависимости от значния search_reg <br> mode = `0x01` result_reg хранит данные, найденные в памяим с ячейкой с индексом равным значению search_reg result_reg = mem[search_reg] <br> mode = `0x02` result_reg хранит индекс ячейки в которой найденыданные равные search_reg reult_reg = index(mem[index] == search_reg), если данные в памяти не найдены, в регистр result_reg записывается 0xffffffff |

###### поля регистра valid

|имя поля|режим доступа|смещение|значение по сбросу|назначение|
|---|---|---|---|---|
|valid_value|RW|[3:0]|0|каждрый бит поля valid_value позволяет определить, хранятся ли данные в ячейке памяти с соответсвущим индексом. После записи в ячейку памяти с интексом i valid_value[i] автоматически устанавливается в 1. Поиск осуществляется только по ячейкам памяти, в которых находятся валидные данные |

###### поля регистра search_reg

|имя поля|режим доступа|смещение|значение по сбросу|назначение|
|---|---|---|---|---|
|data|RW|[31:0]|0| при mode = `0x01` хранит индекс ячейки памяти, из которой надо прочинать данные <br> при mode = `0x02` хранит данные, котоыре должны быть найдены в памяти|

###### поля регистра result_reg

|имя поля|режим доступа|смещение|значение по сбросу|назначение|
|---|---|---|---|---|
|data|RW|[31:0]|не определен| при mode = `0x01` хранит найденные данные <br> при mode = `0x02` хранит индекс ячейки памяти, в которой были найдены данные (0xffffffff, если данные не найдены)|

###### поля регистра cam_mem

|имя поля|режим доступа|смещение|значение по сбросу|назначение|
|---|---|---|---|---|
|data|RW|[31:0]|не определен| ячейка памяти|

###### RTL устройства для изучения
$LAB_HOME/rtl/cam.sv


#### Шаг 1. Познакомиться со структурой окружения


```bash
.                                        // LAB_HOME
├── a_layer_uvc                          // пакет агента A_LAYER 
│   ├── a_layer2dstream_driver.svh
│   ├── a_layer_agent.svh
│   ├── a_layer_item.svh
│   ├── a_layer_pkg.sv
│   ├── a_layer_seq_lib.svh
│   ├── a_layer_sequencer.svh
│   ├── dstream2a_layer_monitor.svh
│   └── reg2a_layer_adapter.svh          // адаптер для регистровой модели
├── cam_ral                              // регистровая модель устройства
│   ├── cam_ral_pkg.sv
│   ├── cam_reg_env.svh                  // обертка для упрощения интеграции в окружение
│   └── cam_regs.svh
├── dstream_uvc                          // пакет агента DSTREAM
│   ├── dstream_agent.svh
│   ├── dstream_config.svh
│   ├── dstream_driver.svh
│   ├── dstream_if.sv
│   ├── dstream_item.svh
│   ├── dstream_monitor.svh
│   ├── dstream_pkg.sv
│   ├── dstream_seq_lib.svh
│   └── dstream_sequencer.svh
├── rtl                                  // RTL модель устройства
│   └── cam.sv
├── sim                                  // папка для запуска моделирования
│   ├── Makefile
│   ├── simulate.tcl
└── tb                                   // тестовое окружение и пример теста
    ├── lab_env_config.svh
    ├── lab_env.svh
    ├── lab_test_example.svh
    ├── lab_test_pkg.sv
    └── tb_top.sv
```



#### Шаг 2. Проверка свойств путём генерации воздействий на уровне интерфейса DSTREAM

запустите сборку и моделирование проекта
```bash
make 
```

clear work dir:
```bash
make clean 
```

пользуйтесь подсказками в комментариях, помеченными `-->`  (см. step 2)
```bash
grep -r '\-\->' $LAB_HOME | grep "step 2"
```


Пример полученного лога
```bash
55000000 DUT BUS WRITE addr=00001000 data=00000001
75000000 DUT BUS READ addr=00001000 data=00000001
95000000 DUT BUS WRITE addr=00002008 data=00003333
115000000 DUT BUS READ addr=00001004 data=00000004
```

для полуения более деьального лога для отладки выполняте запуск с выводом отладоных сообщени от агентов и сбором базы для постанализа
```bash
make sim UVM_VERBOSITY=UVM_DEBUG DUMPDB=1
```

запуск постанализа временных диаграмм
```bash
make view
```

##### Примеры кода, важные для решения лабораторной работы

обратите внимание на пример доступа к регистру ctrl, состоящего из 2х DSTREAM транзакций в файле $LAB_HOME/tb/lab_test_example.svh


#### Шаг 3. Реализация агента для уровня A_LAYER. Проверка свойств путём генерации воздействий на уровне A_LAYER

пользуйтесь подсказками в комментариях, помеченными `-->` (см. step 3)
```bash
grep -r '\-\->' $LAB_HOME | grep "step 3"
```

Пример полученного лога
```bash
55000000 DUT BUS WRITE addr=00001000 data=00000001
75000000 DUT BUS READ addr=00001000 data=00000001
95000000 DUT BUS WRITE addr=00002008 data=00001234
115000000 DUT BUS READ addr=00001004 data=00000004
```

##### Примеры кода, важные для решения лабораторной работы

В коде драйвера работа с последовательностями, приходящими из секвенсера делается аналогично обычному драйверу, за исключением того, что вместо работы с сигналами интерфейса выполняется запуск последовательснти на секвенсере нижнего уровня, ссылка на который передана в процессе создания окружения
```verilog
...
d_seq = dstream_pkg::dstream_seq::type_id::create("addr_tr");
....
d_seq.start(m_dstream_sequencer);
....

```

при реализации монитора обратить внимание на то, что для создания одной транзакции A_LAYER нужно поймать 2 транзакции DSTREAM.

проверки читаемых значений придектся делать явным образом
```verilog
`uvm_do_on_with(my_layer_seq, m_a_layer_sequencer, {m_addr==32'h1000; m_tran_type==A_LAYER_READ;});
if (my_layer_seq.m_data != 1) `uvm_error("TEST_LOG","ctrl state error"); 
```

#### Шаг 4. Реализация регистровой модели устройства. Проверка свойств путём генерации воздейтсивей с использованием регистровой модели

пользуйтесь подсказками в комментариях, помеченными `-->` (см. step 4)
```bash
grep -r '\-\->' $LAB_HOME | grep "step 4"
```

Пример полученного лога
```bash
est_seq [TEST_LOG] check ctrl reset state 
            55000000 DUT BUS READ addr=00001000 data=00000000
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(71) @ 55000000: reporter@@test_seq [TEST_LOG] check ctrl write operation 
            75000000 DUT BUS WRITE addr=00001000 data=00000001
            95000000 DUT BUS READ addr=00001000 data=00000001
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(77) @ 95000000: reporter@@test_seq [TEST_LOG] check valid. Each write to mem impact particular valid bit
           115000000 DUT BUS READ addr=00001004 data=00000000
           135000000 DUT BUS WRITE addr=00002004 data=55556666
           155000000 DUT BUS READ addr=00001004 data=00000002
           175000000 DUT BUS WRITE addr=0000200c data=33334444
           195000000 DUT BUS READ addr=00001004 data=0000000a
           215000000 DUT BUS WRITE addr=00002008 data=12345678
           235000000 DUT BUS READ addr=00001004 data=0000000e
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(93) @ 235000000: reporter@@test_seq [TEST_LOG] search check in mode=1 get data by index
           255000000 DUT BUS WRITE addr=00001008 data=00000001
           275000000 DUT BUS READ addr=0000100c data=55556666
           295000000 DUT BUS WRITE addr=00001008 data=00000002
           315000000 DUT BUS READ addr=0000100c data=12345678
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(104) @ 315000000: reporter@@test_seq [TEST_LOG] search check in mode=2 get index by data
           335000000 DUT BUS WRITE addr=00001000 data=00000002
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(108) @ 335000000: reporter@@test_seq [TEST_LOG] if data not found return ffffffff
           355000000 DUT BUS WRITE addr=00001008 data=11111111
           375000000 DUT BUS READ addr=00001000 data=00000002
           395000000 DUT BUS READ addr=0000100c data=ffffffff
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(115) @ 395000000: reporter@@test_seq [TEST_LOG] if data found return index
           415000000 DUT BUS WRITE addr=00001008 data=55556666
           435000000 DUT BUS READ addr=00001000 data=00000002
           455000000 DUT BUS READ addr=0000100c data=00000001
           475000000 DUT BUS WRITE addr=00001008 data=33334444
           495000000 DUT BUS READ addr=00001000 data=00000002
           515000000 DUT BUS READ addr=0000100c data=00000003
UVM_INFO /home/fputrya/projects_trotter/temp/miee_training/UVM4DV/solutions/lab_07_layering_and_regs/layering_and_regs_example/sim/..//tb/lab_test_example.svh(129) @ 515000000: reporter@@test_seq [TEST_LOG] in mode=0 keep last data
           535000000 DUT BUS WRITE addr=00001000 data=00000000
           555000000 DUT BUS WRITE addr=00001008 data=55556666
           575000000 DUT BUS READ addr=0000100c data=00000003
```

##### Примеры кода, важные для решения лабораторной работы

Поля структуры uvm_reg_bus_op (для адаптера)
```verilog
rw.kind // UVM_WRITE / UVM_READ;
rw.addr // адрес
rw.data // данные
```

для памяти можно использовать специальный класс uvm_mem
```verilog
...
class ral_regs_cam_mem extends uvm_mem;
...
this.default_map.add_mem(this.cam_mem, 
UVM_REG_ADDR_WIDTH'h1000, "RW", 0);
...
```

пример доступа к регистрам посредством регистровой модели
```verilog
// пример установки режима работы
m_ral_model.regs.search_reg.data.set(2);
m_ral_model.regs.search_reg.update(status);
// явная установка ожидаемого значения регистра
predict_status = m_ral_model.regs.result_reg.predict( 32'h12345678 );
// чтение регистра с автоматической проверкой с использованеим занесенного ранее предсказанного значения
m_ral_model.regs.result_reg.mirror(status, .check(UVM_CHECK) );
```

## Использованные ресурсы

1. [Universal Verification Methodology UVM Cookbook](https://verificationacademy.com/cookbook)
2. [layering on doulos два варианта организации layering](https://www.doulos.com/knowhow/systemverilog/uvm/easier-uvm/easier-uvm-deeper-explanations/requests-responses-layered-protocols-and-layered-agents/)
3. [layering on dvcon A Simplified Approach Using UVM Sequence Items for Layering Protocol Verification](https://dvcon-proceedings.org/wp-content/uploads/a-simplified-approach-using-uvm-sequence-items-for-layering-protocol-verification.pdf)
4. [Beyond UVM: Creating Truly Reusable Protocol Layering](https://dvcon-proceedings.org/wp-content/uploads/beyond-uvm-creating-truly-reusable-protocol-layering.pdf) 
5. [Advanced UVM Register Modeling](https://dvcon-proceedings.org/wp-content/uploads/advanced-uvm-register-modeling.pdf)
6. [UVM Register example on ChipVerify](https://www.chipverify.com/uvm/uvm-register-model-example)
7. [UVM Tutorial for Candy Lovers – 16. Register Access Methods](http://cluelogic.com/2013/02/uvm-tutorial-for-candy-lovers-register-access-methods/)