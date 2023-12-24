# Лабораторная работа 1 "UVM: Введение, основные концепции, базовые классы"


## Цель

Познакомиться с основыми концепциями UVM, научиться использовать базовые классы и фабрику.

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


### Примеры кода, важные для решения лабораторной работы


uvm_object_utils - макрос, подставляющий функции и определения для корректной регистрации объекта в фабрике:
```verilog
class my_obj_a extends uvm_object;
   `uvm_object_utils(my_obj_a)
```

uvm_component_utils - макрос, подставляющий функции и определения для корректной регистрации объекта в фабрике:
```verilog
class my_comp_b extends uvm_component;
    `uvm_component_utils(my_comp_b)
```

Макрос для вызова тестовой печати UVM_NONE, UVM_FULL - VERBOSITY для данного сообщения:
```verilog
`uvm_info("MY_COMPS", "MY_TOP_COMP BUILD", UVM_NONE);
`uvm_info("MY_COMPS", "MY_TOP_COMP DEBUG MESSAGE", UVM_FULL);
`uvm_warning("MY_COMPS", "MY_TOP_COMP WARNING MESSAGE");
```

Пример создания объекта через фабрику посредством вызова метода create:
```verilog
function void build_phase(uvm_phase phase);
    `uvm_info("MY_COMPS", "MY_TOP_COMP BUILD", UVM_NONE);
    m_my_comp_a = my_comp_a::type_id::create("m_my_comp_a", this);
endfunction
```

---

## Ход работы

#### Шаг 0. Проверка работоспособности заготовки

```bash
cd lab_01_uvm_basics/uvm_obj_and_comp_example/sim
```
Проект должен собраться и выдать сообщение об успешном прохождении

```bash
** Report counts by severity
UVM_INFO :    8
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[LAB01]     4
[MY_COMPS]     3
[RNTST]     1
```

#### Шаг 1. Создаём иерархию компонент
* в файле 
`lab_01_uvm_basics/uvm_obj_and_comp_example/tb/my_comps_and_objs.svh `
создайте два компонента (`my_comp_a`, `my_comp_b`) и один объект (`my_obj_a`)
* в компоненте my_top_comp, а также в классе окружения (`lab_01_uvm_basics/uvm_obj_and_comp_example/tb/env.svh`) выполните создание компонент с использованием фабрики
Пункты требуется выполнить таким образом, чтобы после запуска теста получить следующую иерархию (Value может расходится)

пользуйтесь подсказками в комментариях, помеченными `-->`

```
----------------------------------------------
Name                 Type          Size  Value
----------------------------------------------
uvm_test_top         test_example  -     @2608
  m_env              env           -     @2686
    m_my_top_comp_0  my_top_comp   -     @2719
      m_my_comp_a    my_comp_a     -     @2812
      m_my_comp_b    my_comp_b     -     @2844
    m_my_top_comp_1  my_top_comp   -     @2749
      m_my_comp_a    my_comp_a     -     @2889
      m_my_comp_b    my_comp_b     -     @2890
    m_my_top_comp_2  my_top_comp   -     @2779
      m_my_comp_a    my_comp_a     -     @2920
      m_my_comp_b    my_comp_b     -     @2950
----------------------------------------------
```

Проверить результат запуска теста можно в файле `lab_01_uvm_basics/uvm_obj_and_comp_example/sim/simulation.log`:


в функуции build_phase по аналогии с компонентом my_top_comp вставьте печать сообщений, таким образом, чтобы в логе теста сформировалась следующуюя последовательность сообщений:

```
uvm_test_top [LAB01] BUILDING ENV
uvm_test_top.m_env.m_my_top_comp_0 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_0 [MY_COMPS] print from my_top_comp build_phase (end)
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (end)
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1 [MY_COMPS] print from my_top_comp build_phase (end)
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (end)
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (end)
uvm_test_top.m_env.m_my_top_comp_2 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_2 [MY_COMPS] print from my_top_comp build_phase (end)
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (end)
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (end)
```

#### Шаг 2. Управляем тестовой печатью

модифицируя вызовы методов печати добейтесь того, чтобы при вызоыве
```bash
make UVM_VERBOSITY=UVM_MEDIUM
```
печатался такой же вывод, как и в шаге 1, 

а при вызове
```bash
make UVM_VERBOSITY=UVM_LOW
```
получалась бы печать как в листинге ниже

```bash
uvm_test_top [LAB01] BUILDING ENV
uvm_test_top.m_env.m_my_top_comp_0 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
uvm_test_top.m_env.m_my_top_comp_2 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_b [MY_COMPS] print from my_comp_b build_phase (start)
```

#### Шаг 3. Перегружаем типы создаваемых объектов и классов 

В файле `lab_01_uvm_basics/uvm_obj_and_comp_example/tb/test_example.svh` создайте два класса my_new_comp_a и my_new_comp_b, отнаследованных соответсвенно от классов my_comp_a и my_comp_b;
Модифицируя только файл test_example.sv (не модифицируя файлы my_comps_and_objs.svh и env.svh) с помощью переопределения созаваяемых типов с использованием фабрики добейтесь получения иерархии и печати, пример которой приведен ниже:

```
uvm_test_top [LAB01] BUILDING ENV
uvm_test_top.m_env.m_my_top_comp_0 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_0.m_my_comp_b [MY_COMPS] print from my_new_comp_b build_phase
uvm_test_top.m_env.m_my_top_comp_1 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_a [MY_COMPS] print from my_new_comp_a build_phase
uvm_test_top.m_env.m_my_top_comp_1.m_my_comp_b [MY_COMPS] print from my_new_comp_b build_phase
uvm_test_top.m_env.m_my_top_comp_2 [MY_COMPS] print from my_top_comp build_phase (start)
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_a [MY_COMPS] print from my_comp_a build_phase (start)
reporter [MY_COMPS] print from my_obj_a new
uvm_test_top.m_env.m_my_top_comp_2.m_my_comp_b [MY_COMPS] print from my_new_comp_b build_phase
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------
Name                 Type           Size  Value
-----------------------------------------------
uvm_test_top         test_example   -     @2610
  m_env              env            -     @2699
    m_my_top_comp_0  my_top_comp    -     @2732
      m_my_comp_a    my_comp_a      -     @2693
      m_my_comp_b    my_new_comp_b  -     @2857
    m_my_top_comp_1  my_top_comp    -     @2762
      m_my_comp_a    my_new_comp_a  -     @2897
      m_my_comp_b    my_new_comp_b  -     @2935
    m_my_top_comp_2  my_top_comp    -     @2792
      m_my_comp_a    my_comp_a      -     @2903
      m_my_comp_b    my_new_comp_b  -     @3000
-----------------------------------------------
```


