# PS4-Saves-II

Saves de PlayStation 4 — **34 títulos**, 2,0G.

Estrutura no padrão do console: `PS4/SAVEDATA/6f5440249bc89152/<CUSA>/`.
Para restaurar, copie a pasta `PS4` para a raiz de um pendrive formatado em exFAT
e use *Configurações → Gerenciamento de dados salvos → Armazenamento USB*.

> Os saves são vinculados à conta `6f5440249bc89152`. Em outra conta exigem
> re-assinatura (Save Wizard, Apollo ou similar).

Títulos marcados com ⚠️ estão em zip dividido em volumes de 90 MB, porque o
GitHub rejeita arquivos acima de 100 MB. Para restaurar, junte os volumes antes:

```bash
zip -s 0 CUSA09209.zip --out completo.zip   # junta .z01, .z02... + .zip
unzip completo.zip -d CUSA09209
```

| | Título | CUSA | Slots | Tamanho |
|---|---|---|---:|---:|
| <img src="assets/icons/CUSA00021.webp" width="60"> | WATCH_DOGS™ | `CUSA00021` | 3 | 30,0 MB |
| <img src="assets/icons/CUSA00068.webp" width="60"> | KNACK™ | `CUSA00068` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA00079.webp" width="60"> | Injustice: Gods Among Us Ultimate Edition | `CUSA00079` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA00083.webp" width="60"> | LEGO® MARVEL Super Heroes | `CUSA00083` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA00304.webp" width="60"> | Trials Fusion™ | `CUSA00304` | 1 | 100,0 MB |
| <img src="assets/icons/CUSA00341.webp" width="60"> | Uncharted 4: A Thief’s End™ | `CUSA00341` | 2 | 20,0 MB |
| <img src="assets/icons/CUSA00552.webp" width="60"> | The Last of Us™ Remastered | `CUSA00552` | 5 | 15,0 MB |
| <img src="assets/icons/CUSA00663.webp" width="60"> | Assassin's Creed® Unity | `CUSA00663` | 3 | 23,0 MB |
| <img src="assets/icons/CUSA00900.webp" width="60"> | Bloodborne™ | `CUSA00900` | 1 | 35,5 MB |
| <img src="assets/icons/CUSA01047.webp" width="60"> | Ratchet & Clank™ | `CUSA01047` | 1 | 3,0 MB |
| <img src="assets/icons/CUSA01200.webp" width="60"> | STREET FIGHTER V | `CUSA01200` | 2 | 20,3 MB |
| <img src="assets/icons/CUSA01341.webp" width="60"> | DRAGON BALL XENOVERSE | `CUSA01341` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA01608.webp" width="60"> | Enter the Gungeon | `CUSA01608` | 1 | 37,2 MB |
| <img src="assets/icons/CUSA02107.webp" width="60"> | LEGO® MARVEL's Avengers | `CUSA02107` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA02299.webp" width="60"> | Marvel's Spider-Man | `CUSA02299` | 27 | 81,0 MB |
| <img src="assets/icons/CUSA02320.webp" width="60"> | Uncharted: The Nathan Drake Collection™ | `CUSA02320` | 5 | 50,0 MB |
| <img src="assets/icons/CUSA02389.webp" width="60"> | Assassin's Creed® Syndicate | `CUSA02389` | 2 | 13,0 MB |
| <img src="assets/icons/CUSA02420.webp" width="60"> | Darksiders II Deathinitive Edition | `CUSA02420` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA03506.webp" width="60"> | Grand Theft Auto: San Andreas | `CUSA03506` | 1 | 18,3 MB |
| <img src="assets/icons/CUSA03509.webp" width="60"> | Grand Theft Auto: Vice City | `CUSA03509` | 1 | 18,3 MB |
| <img src="assets/icons/CUSA03962.webp" width="60"> | RESIDENT EVIL 7 biohazard | `CUSA03962` | 4 | 66,0 MB |
| <img src="assets/icons/CUSA04885.jpg" width="60"> | Resident Evil 4 (HD 2016) | `CUSA04885` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA07326.webp" width="60"> | Horizon Zero Dawn: Complete Edition (The Frozen Wilds) | `CUSA07326` | 14 | 128,0 MB |
| <img src="assets/icons/CUSA07402.webp" width="60"> | Crash Bandicoot N. Sane Trilogy | `CUSA07402` | 2 | 16,0 MB |
| <img src="assets/icons/CUSA07408.webp" width="60"> | God of War | `CUSA07408` | 1 | 37,2 MB |
| <img src="assets/icons/CUSA08038.webp" width="60"> | FIFA 18 | `CUSA08038` | 24 | 432,0 MB |
| <img src="assets/icons/CUSA08282.webp" width="60"> | PRO EVOLUTION SOCCER 2018 | `CUSA08282` | 17 | 322,3 MB |
| <img src="assets/icons/CUSA08966.webp" width="60"> | DAYS GONE | `CUSA08966` | 3 | 77,0 MB |
| <img src="assets/icons/CUSA10483.webp" width="60"> | Unravel TWO | `CUSA10483` | 1 | 10,0 MB |
| <img src="assets/icons/CUSA12358.webp" width="60"> | DRAGON BALL XENOVERSE 2 Lite | `CUSA12358` | 1 | 3,0 MB |
| <img src="assets/icons/CUSA14034.webp" width="60"> | PRO EVOLUTION SOCCER 2019 LITE | `CUSA14034` | 6 | 66,7 MB |
| <img src="assets/icons/CUSA17965.webp" width="60"> | eFootball PES 2020 LITE | `CUSA17965` | 3 | 53,2 MB |
| <img src="assets/icons/CUSA34384.webp" width="60"> | God of War Ragnarök | `CUSA34384` | 17 | 138,0 MB |
| <img src="assets/icons/CUSA45923.webp" width="60"> | Pool Blitz | `CUSA45923` | 20 | 198,8 MB |

<sub>Gerado por `tools/build_index.sh` — não edite esta tabela à mão.</sub>
