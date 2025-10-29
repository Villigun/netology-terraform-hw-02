# Домашнее задание к занятию - «Основы Terraform. Yandex Cloud» - Колесин Владимир.

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git. Убедитесь что ваша версия Terraform ~>1.12.0

1.  Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2.  Создайте сервисный аккаунт и ключ. service_account_key_file.
3.  Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.
4.  Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
5.  Подключитесь к консоли ВМ через ssh и выполните команду  curl ifconfig.me. Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address". Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: eval $(ssh-agent) && ssh-add Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
6.  Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.

В качестве решения приложите:
* скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
* скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
* ответы на вопросы.

# Решение

2.  Создаем сервисный аккаунт и IAM-токен (вероятно это имелось в виду под "ключ")

```
yc iam service-account create --name netology
done (2s)
id: aje6ucreuv3kgaqreb8s
folder_id: b1g57c69inml3980vmeg
created_at: "2025-10-28T07:59:02.159066522Z"
name: netology

yc resource-manager folder add-access-binding b1g57c69inml3980vmeg --role editor --subject serviceAccount:aje6ucreuv3kgaqreb8s
done (3s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: aje6ucreuv3kgaqreb8s
        type: serviceAccount

yc iam key create --service-account-name netology --output authorized_key.json
id: aje3196c7q4q0brcjb99
service_account_id: aje6ucreuv3kgaqreb8s
created_at: "2025-10-28T08:23:41.945287631Z"
key_algorithm: RSA_2048
```

3.  У меня имеется SSH ключ, записать его публичную часть в переменную TF_VAR можно командой

`export TF_VAR_vms_ssh_public_root_key="$(cat ~/.ssh/имя_файла_ключа.pub)"`

но я предпочту передавать этот ключ в терраформ через 

```
# В terraform.tfvars
ssh_public_key_path = "путь_к_ключу"

# В locals.tf
locals {
  ssh_public_key = sensitive(file(var.ssh_public_key_path))
}

# В variables.tf
variable "ssh_public_key_path" {
  description = "Путь к SSH публичному ключу"
  type        = string
}

# В main.tf, секция создания ВМ
  metadata = {
    serial-port-enable = 1
    ssh-keys  = "ubuntu:${local.ssh_public_key}"
  }
```

Я считаю, что в этом случае улучшается читаемость кода - другой специалист, просмотрев terraform.tfvars, сразу поймет куда надо положить ключ или легко поправит путь к нему.  
Чтобы ключ не светился в terrafom plan добавляем sensitive в locals.tf.

4.  Для начала создаем terraform.tfvars, куда прописываем значения cloud_id, older_id и default_zone, которые описаны в variables.tf, но им не присвоено значение по умолчанию.Затем инициализируем проект и правим ошибки

```
terraform validate
╷
│ Error: Invalid function argument
│
│   on providers.tf line 15, in provider "yandex":
│   15:   service_account_key_file = file("~/.authorized_key.json")
│     ├────────────────
│     │ while calling file(path)
│
│ Invalid value for "path" parameter: no file exists at "~/.authorized_key.json"; this function works only with files that are distributed as part of the configuration source code, so if this     
│ file will be created by a resource in this configuration you must instead obtain this result from an attribute of that resource.
```

Ошибка в имени файла authorized_key.json - он указан с точкой, а yc cli сохранил этот файл без точки в начале, т.е. не скрытым.
Нам скрывать нечего :-) и работаем из под windows, по этому правим путь в providers.tf

```
terraform validate
Success! The configuration is valid.
```

При terraform apply получаем ошибку, которую предвидели ранее при изучении main.tf

```
Error: Error while requesting API to create instance: client-request-id = 8ecf66fe-434c-4714-87b9-6992014642f4 client-trace-id = 55ae058c-0522-4890-b3ac-fb902bee002a rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
│
│   with yandex_compute_instance.platform,
│   on main.tf line 16, in resource "yandex_compute_instance" "platform":
│   16: resource "yandex_compute_instance" "platform" {
```

Правильное написание - standard, и, согласно [списку доступных платформ](https://yandex.cloud/ru/docs/compute/concepts/vm-platforms), standard-v4 не существует. Доступно standard-v4a с характиристиками черезвычайно завышенными для нашего задания. Остановимся на standard-v1 и заодно поправим кол-во ядер - допустимо 2 или 4.

```
terraform apply -auto-approve
data.yandex_compute_image.ubuntu: Reading...

# Куча текста

yandex_compute_instance.platform: Creation complete after 2m19s [id=fhm1cdkpgna89csmoipr]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

ВМ запущена

![alt text](КАРТИНКА img1-01)

5.  Для удобства, чтобы не лазить каждый раз в web-интерфейс yandex cloud, который при создании ВМ назначает ей ip-addres по dhcp, добавим в outputs.tf вывод внешнего ip-адреса нашей ВМки.

```
# outputs.tf
output "platform_external_ip" {
  description = "Внешний IP адрес виртуальной машины"
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}
```

Подключаемся через putty или secureCRT и выполняем команду

```
ubuntu@fhm1cdkpgna89csmoipr:~$ curl ifconfig.me
158.160.40.133ubuntu@fhm1cdkpgna89csmoipr:~$ 
```

6.  Параметр preemptible = true делает ВМку прерываемой, т.е. через 24 часа она автоматически остановится, а core_fraction=5 определяет 5% резервирования процессорного времени.  
    Оба параметра позволяют экономить бюджет миссии.  

### Задание 2
1.  Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
2.  Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
3.  Проверьте terraform plan. Изменений быть не должно.

# Решение

Изменения коснутся таких значений как family, name, platform_id, cores, memory, core_fraction и, на всякий случай, имени пользователя ВМ (ubuntu).  
Создаем в variables.tf описание соответствующих переменных, а в main.tf указываем обращения к ним в соответствующих полях (см [variables.tf](ССЫЛКА на Z2) и [main.tf](ССЫЛКА на Z2)).
terraform plan ошибок не показал, ВМ создается с теми же параметрами.

### Задание 3
1.  Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2.  Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" , cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf'). ВМ должна работать в зоне "ru-central1-b"
3.  Примените изменения.

# Решение

Создали, скопировали, объявили, поправили, исправили, дописали и так несколько раз.
Итог:

```
terraform apply -auto-approve  
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8fatq8necmfrsdret4]

# Куча текста

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

db_external_ip = "158.160.3.23"
platform_external_ip = "51.250.8.55"

# Проверка

yc vpc network list
+----------------------+---------+
|          ID          |  NAME   |
+----------------------+---------+
| enp8fcbqldmp4dq97qt0 | default |
| enpl6qsbk4vtsuvncfcv | develop |
+----------------------+---------+

yc vpc subnet list
+----------------------+---------+----------------------+----------------+---------------+------------------+
|          ID          |  NAME   |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |      RANGE       |
+----------------------+---------+----------------------+----------------+---------------+------------------+
| e2l0i55efqdofi9ed7rl | db      | enpl6qsbk4vtsuvncfcv |                | ru-central1-b | [10.0.2.0/24]    |
| e2l3r14oa7f20914v1s4 | default | enp8fcbqldmp4dq97qt0 |                | ru-central1-b | [192.168.0.0/24] |
| e9b225or87n6kfcvkamd | develop | enpl6qsbk4vtsuvncfcv |                | ru-central1-a | [10.0.1.0/24]    |
+----------------------+---------+----------------------+----------------+---------------+------------------+

yc compute instance list
+----------------------+-------------------------------+---------------+---------+--------------+--------------+
|          ID          |             NAME              |    ZONE ID    | STATUS  | EXTERNAL IP  | INTERNAL IP  |
+----------------------+-------------------------------+---------------+---------+--------------+--------------+
| epd2asqg4dstr5ejvrlk | netology-develop-platform-db  | ru-central1-b | RUNNING | 158.160.3.23 | 10.0.2.22    |
| fhmgbdjbk2na2c7ge8ki | netology-develop-platform-web | ru-central1-a | RUNNING | 51.250.8.55  | 10.0.1.7     |
+----------------------+-------------------------------+---------------+---------+--------------+--------------+
```

![alt text](КАРТИНКА img3-01)

### Задание 4
1.  Объявите в файле outputs.tf один output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
Примените изменения.
2.  В качестве решения приложите вывод значений ip-адресов команды terraform output.

# Решение

1.  [Ссылка на outputs.tf](!!! Ссылка на z4!!!)

2.  

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

vm_info = {
  "netology-develop-platform-db" = {
    "external_ip" = "84.252.139.155"
    "fqdn" = "epdc422acpv637d9lkst.auto.internal"
    "instance_name" = "netology-develop-platform-db"
  }
  "netology-develop-platform-web" = {
    "external_ip" = "158.160.116.216"
    "fqdn" = "fhm6lhd3tpl4mnaorsco.auto.internal"
    "instance_name" = "netology-develop-platform-web"
  }
}
```

### Задание 5
1.  В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2.  Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3.  Примените изменения.

# Решение

Вносим ищменения в [Ссылка на locals.tf](!!! Ссылка на z5!!!) и [Ссылка на main.tf](!!! Ссылка на z5!!!)
Применяем изменения. Результат не изменился:

![alt text](КАРТИНКА img5-01)

### Задание 6
1.  Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в единую map-переменную vms_resources и внутри неё конфиги обеих ВМ в виде вложенного map(object).

```
пример из terraform.tfvars:
vms_resources = {
  web={
    cores=2
    memory=2
    core_fraction=5
    hdd_size=10
    hdd_type="network-hdd"
    ...
  },
  db= {
    cores=2
    memory=4
    core_fraction=20
    hdd_size=10
    hdd_type="network-ssd"
    ...
  }
}
```

Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.

```
пример из terraform.tfvars:
metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
}
```

3.  Найдите и закоментируйте все, более не используемые переменные проекта.
4.  Проверьте terraform plan. Изменений быть не должно.

# Решение

1.  В terraform.tfvars создаем map-переменную vms_resources с описанием конфигураций ВМок. Помимо core, memory и core_fraction добавим для удобства name, zone и platform_id, чтобы все данные о конфигурации хранились в одном месте. Затем описываем эту переменную в variables.tf.
2.  По аналогии с предыдущим пунктом создаем и описываем переменную metadata. Обращаем внимание на то, что SSH-ключ здесь хранится в открытом тексте, хотя нас учили, что это ай-ай-ай - не хорошо. Необходимо убрать ключ и закоментировать блокировку отправки в .gitignore.
3.  Находим, комментируем. Получается что в [vms_platform.tf](!!! Ссылка на z6), остается описание только одной переменной vm_web_ci_image, [locals.tf](!!! Ссылка на z6) вообще пустая, в [variables.tf](!!! ССылка на z6) добавились описания переменных vms_resources и metadata, несколько разросся [terraform.tfvars](!!! Ссылка на z6)

Вывод - используя map, можно существено сократить код и добиться его лаконичности.
