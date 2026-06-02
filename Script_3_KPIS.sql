use dashboard_ventas;
select 
	date_format(fecha, '%Y-%m') as mes,
    round(sum(total_venta),2) as ventas_mes,
    round(avg(total_venta),2) as ticket_promedio,
    round(
		(sum(total_venta) - lag(sum(total_venta))over (order by date_format(fecha,'%Y-%m')))/ lag(sum(total_venta))
            over (order by date_format(fecha,'%Y-%m'))*100,1) as crecimiento_pct
	from ventas
    group by mes
    order by mes;
    
select 
	v.nombre, v.zona,
	round(sum(vt.total_venta)/count(distinct date_format(vt.fecha,'%Y-%m'))/v.meta_mensual * 100,1) as cumplimiento_pct,
	case 
		when sum(vt.total_venta)/count(distinct date_format(vt.fecha,'%Y-%m'))/v.meta_mensual >=1 then 'cumplio' 
		when sum(vt.total_venta)/count(distinct date_format(vt.fecha,'%Y-%m'))/v.meta_mensual >= 0.8 then 'cerca'
		else 'no cumplio'
	end  as estado_meta	
from vendedores v
join ventas vt on v.vendedor_id = vt.vendedor_id
group by v.vendedor_id, v.nombre, v.zona, v.meta_mensual
order by cumplimiento_pct desc
limit 10;

#top 10 vendedores
select v.nombre, v.zona,
		round(sum(vt.total_venta),2) as total_vendido,
        round(avg(vt.total_venta),2) as total_promedio
from ventas vt
join vendedores v on vt.vendedor_id=v.vendedor_id
group by v.vendedor_id, v.nombre, v.zona
order by total_vendido desc limit 10;

#top 10 productos
select producto, categoria,
	sum(cantidad) as unidades,
    round(sum(total_venta),2) as ingresos
from ventas 
group by producto, categoria
order by ingresos desc limit 10;



