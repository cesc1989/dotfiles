# Índice de Funciones - Dotfiles

Este archivo contiene un índice de todas las funciones disponibles en la carpeta `functions` con ejemplos de uso.

## Funciones de Kubernetes (Alpha Pods)

### `alpha_therapists_pod`
**Archivo:** `alpha_pod_functions.sh`
**Alias:** `pat`
Accede automáticamente al pod más reciente del servicio therapists en Alpha.

**Ejemplo:**
```bash
alpha_therapists_pod
```

### `alpha_edge_pod`
**Archivo:** `alpha_pod_functions.sh`
**Alias:** `pae`
Accede automáticamente al pod más reciente del servicio edge en Alpha.

**Ejemplo:**
```bash
alpha_edge_pod
```

### `alpha_marketplace_pod`
**Archivo:** `alpha_pod_functions.sh`
**Alias:** `pam`
Accede automáticamente al pod más reciente del servicio marketplace en Alpha.

**Ejemplo:**
```bash
alpha_marketplace_pod
```

### `alpha_grimoire_pod`
**Archivo:** `alpha_pod_functions.sh`
**Alias:** `pag`
Accede automáticamente al pod más reciente del servicio grimoire en Alpha.

**Ejemplo:**
```bash
alpha_grimoire_pod
```

### `alpha_service_pod`
**Archivo:** `alpha_pod_functions.sh`
Accede a un pod específico de un servicio en Alpha.

**Ejemplo:**
```bash
alpha_service_pod therapists [POD_ID]
alpha_service_pod edge [POD_ID]
alpha_service_pod marketplace [POD_ID]
```

## Funciones de Compresión

### `compress_with_tar`
**Archivo:** `compress_with_tar.sh`
Comprime archivos o directorios usando tar con compresión gzip.

**Ejemplo:**
```bash
compress_with_tar my_folder my_archive.tar.gz
compress_with_tar file.txt backup.tar.gz
```

## Funciones de Configuración

### `copy_zed_settings`
**Archivo:** `copy_zed_settings.sh`
Copia la configuración y keymaps de Zed a la carpeta Mega según el sistema operativo.

**Ejemplo:**
```bash
copy_zed_settings
```

## Funciones de Git

### `create_git_worktree`
**Archivo:** `create_git_worktree.sh`
Crea un worktree de git fuera del directorio actual y copia archivos de configuración.

**Ejemplo:**
```bash
create_git_worktree sftptodrive edg_2048_sftp_to_gdrive
```

## Funciones de Base de Datos

### `create_local_dump_from_remote`
**Archivo:** `create_local_dump_from_remote_source.sh`
Crea un dump local desde una URL remota de base de datos usando pg_dump.

**Ejemplo:**
```bash
set +H  # Deshabilitar expansión de historial para passwords con !
create_local_dump_from_remote -n edge_alpha -u "postgres://user:pass@host:port/dbname"
```

### `restore_db_from_dump`
**Archivo:** `restore_db_from_dump.sh`
Restaura (crea) una base de datos local desde un archivo dump.

**Ejemplo:**
```bash
restore_db_from_dump -d luna_api_development_X -f ~/Downloads/edge_dump_xxxx
```

## Funciones Misceláneas

### `setaws`
**Archivo:** `misc_functions.sh`
Cambia entre varias cuentas AWS configuradas en `~/.aws/config`.

**Ejemplo:**
```bash
setaws alpha
setaws omega
```

### `headers_from_ruby_hash`
**Archivo:** `misc_functions.sh`
Convierte un hash de Ruby con credenciales en cabeceras HTTP para Postman.

**Ejemplo:**
```bash
ruby_hash='{"access-token"=>"token", "token-type"=>"Bearer", "client"=>"client_id", "expiry"=>"timestamp", "uid"=>"email", "Authorization"=>"bearer_token"}'
headers_from_ruby_hash "$ruby_hash"
```

### `headers_from_hash_with_ruby`
**Archivo:** `misc_functions.sh`
Similar a `headers_from_ruby_hash` pero usa Ruby para procesar el hash.

**Ejemplo:**
```bash
headers_from_hash_with_ruby "$ruby_hash"
```

### `json_oneliner`
**Archivo:** `misc_functions.sh`
Convierte JSON a formato de una sola línea.

**Ejemplo:**
```bash
json_oneliner file.json
cat file.json | json_oneliner
```

### `cat_gemfile`
**Archivo:** `rails_utils.sh`
Muestra la versión instalada de una gema en el Gemfile.lock.

**Ejemplo:**
```bash
cat_gemfile rails
```

### `matar_servidor_rails`
**Archivo:** `rails_utils.sh`
Mata el servidor Rails en el puerto 3000.

**Ejemplo:**
```bash
matar_servidor_rails
```

## Funciones de AWS S3

### `alpha_s3_ls`
**Archivo:** `s3_functions.sh`
Lista contenido de buckets S3 en Alpha.

**Ejemplo:**
```bash
alpha_s3_ls luna-alpha-workloads-data-lake/
alpha_s3_ls luna-alpha-workloads-data-lake/business-operations/
```

### `alpha_s3_cp`
**Archivo:** `s3_functions.sh`
Copia archivos entre local y buckets S3 en Alpha.

**Ejemplo:**
```bash
alpha_s3_cp ~/Downloads/archivo.txt s3://luna-alpha-workloads-data-lake/business-operations/
alpha_s3_cp s3://luna-alpha-workloads-data-lake/business-operations/archivo.txt ~/Downloads/archivo.txt
```

## Funciones de Therapist Signup

### `alpha_signup_files`
**Archivo:** `therapist_signup_files.sh`
Explora archivos en el bucket de Therapist Signup en Alpha.

**Ejemplo:**
```bash
alpha_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb
alpha_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb/attestation
```

### `omega_signup_files`
**Archivo:** `therapist_signup_files.sh`
Explora archivos en el bucket de Therapist Signup en Omega.

**Ejemplo:**
```bash
omega_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb
```

### `omega_copy_signup_files`
**Archivo:** `therapist_signup_files.sh`
Copia archivos de Therapist Signup de Omega a carpeta local.

**Ejemplo:**
```bash
omega_copy_signup_files [UUID] [FILE_NAME]
```

### `alpha_copy_signup_files`
**Archivo:** `therapist_signup_files.sh`
Copia archivos de Therapist Signup de Alpha a carpeta local.

**Ejemplo:**
```bash
alpha_copy_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb attestation/friendly_packet_2025-05-12.pdf
```
