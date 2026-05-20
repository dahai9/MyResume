# MyResume

一个 YAML 文件定义所有内容，在线编辑，实时预览，可一键导出 PDF。

[示例简历 PDF](https://github.com/lvy010/X-Plore/blob/main/data/CV.pdf)

克隆仓库 → 编辑 `resume.yaml` → 启动服务 → 浏览器打开即可预览和导出。

## Preview

```
http://localhost:8010/resume    ← 简历预览（带「导出 PDF」按钮）
http://localhost:8010/editor    ← 左侧 YAML 编辑 + 右侧实时预览
```

![编辑器](./png/edit.png)

![导出 PDF](./png/pdf.png)

## Quick Start

需要 Python 3.10+ 与 [uv](https://docs.astral.sh/uv/)。

```bash
git clone https://github.com/<your-name>/MyResume.git
cd MyResume
uv sync
uv run uvicorn app:app --reload --host 127.0.0.1 --port 8010
```

也可以使用脚本：

```bash
bash start.sh
```

启动后访问 [http://localhost:8010](http://localhost:8010)。

## How It Works

```
resume.yaml          ← 你的简历数据（唯一需要编辑的文件）
templates/resume.html ← Jinja2 渲染模板
static/style.css      ← 样式（A4 排版、编辑器布局、打印适配）
app.py                ← FastAPI 服务
pyproject.toml        ← uv 管理的项目依赖
```

### 编辑简历

**方式 A**：直接编辑 `resume.yaml`，保存后刷新页面。

**方式 B**：打开 `/editor`，在浏览器内编辑 YAML，点击保存，右侧实时预览。

### 导出 PDF

预览页顶部有「导出 PDF」按钮，点击后调用浏览器打印，选择"另存为 PDF"即可。

> 建议使用 Chrome/Edge，打印时取消页眉页脚，边距选"无"，效果最佳。

## YAML Structure

```yaml
basics:           # 姓名、岗位、联系方式、photo 证件照路径
education:        # 学习经历
code:             # 代码链接（GitHub、作品集等）
personal_docs:    # 个人文档/博客/专栏
team_projects:    # 团队项目（公司、Hackathon 等）
personal_projects: # 个人项目
lab_tutorials:    # 实验教程
```

照片字段放在 `basics.photo`。可以写相对静态资源路径，例如 `/static/photo.jpg`，或直接写在线图片 URL；留空时页面会在右上角显示姓名缩写占位。

完整示例见 [`examples/lvy.yaml`](./examples/lvy.yaml)。

## API

| Method | Path | Description |
|--------|------|-------------|
| `GET`  | `/resume` | HTML 简历预览 |
| `GET`  | `/editor` | YAML 编辑器 |
| `GET`  | `/api/resume` | JSON 格式简历数据 |
| `PUT`  | `/api/resume` | JSON 覆盖更新 |
| `GET`  | `/api/resume/raw` | 获取原始 YAML |
| `PUT`  | `/api/resume/raw` | 保存原始 YAML |
| `GET`  | `/docs` | OpenAPI 文档 |

## Docker

```bash
docker build -t myresume .
docker run -p 8010:8010 myresume
```

Acknowledgements
- https://github.com/hijiangtao/resume
- https://github.com/yamlresume/yamlresume

## License

MIT
